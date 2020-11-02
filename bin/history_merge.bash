#!/bin/bash
# vim:ft=bash
#
# Sort history file by timestamp
#
# This can be used to merge two or more copies of history, for example
# the ".bash_history" on disk, and the in-memory history.
#
# The command order preserved for the same timestamp, which can happen when
# timestamps are first enabled (setting $HISTTIMEFORMAT).
#
# This assumes files has bash timestamps.  That is $HISTTIMEFORMAT is set, even
# if set to '' so as to not print timespames in "history" command output.  If
# it is NOT set, then the whole history file will be thought to be a single
# command.
#
# Adjust script to suit your needs...
#
# Optional code to clean our commands which are 'too simple', or may contain
# sensitive information like passwords.
#
####
#
# These are the setting I use in my ".bash_profile"
#
#   HISTTIMEFORMAT=''       # Save the timestamp, but don't output it
#   #HISTTIMEFORMAT='%F_%T ' # output the time in 'history' see "ht" alias
#
#   # Some handle shorthand aliases...
#   h()  { history 30; }                           # last few history commands
#   ht() { HISTTIMEFORMAT='%F_%T  ' history 30; }  # history with time stamps
#   hc() { source ~/bin/history_merge.bash; }      # merge & clean history
#
# And in my ".bash_logout" I have
#
#   # clean histroy before exit
#   hc
#
####
#
# WARNING: some sort of file locking should probbaly be performed.
# to prevent two bash shells doing a merge sumiltaniously.
#
# Anthony Thyssen,   8 October 2020
#

# DO not merge if history save has been disabled (eg: for crypto work)
if [[ -e "$HISTFILE" ]]; then

  # Temporary file for processing
  histtmp=$( mktemp "${TMPDIR:-/tmp}/bash_history_merge.XXXXXXXXXX" )

  # Break up history into NUL separate records
  # This makes processing a LOT easier!
  #
  # This also defines the sources of the history being merged...
  #
  perl -pe '$_ = "\0$_" if /^#\d+/'  "$HISTFILE" <(history -w /dev/stdout) |

  # At this point we could just sort by timestamps, and remove the NULs.
  # HOWEVER: records with same timestamp will have the commands sorted too!
  # WARNING: "sort -u -z" does not work, thus the separate "uniq" command.
  #
  # sort -z | uniq -z | tr -d '\0'

  # Perl history merge..
  #
  # This perl sort, also preserves the order of lines with the same timestamp.
  # While removing lines where the commands (even with different timestamps)
  # are the same.
  #
  # It also optionally cleans out things I do not want saved in my history
  # generally as they are ultra simplistic or cryptograpic commands.
  #
  perl -0 -e '
    while(<>) {   # read it all into memory
      s/\0//;
      next unless length;
      my ( $time, $command ) = split("\n",$_,2);
      $time =~ s/^#(\d+).*/$1/g; # extract the timestamp (and nothing else)
      $command =~ s/^\s+//;      # ignore spaces at start and end
      $command =~ s/\s+$//;      # (not intervening lines (quoted indentation)
                                 # Note commands may be multiple-lines!
      next unless length($command); # blank command

      # Optional Code  -- Remove specific commands from history
      #
      # Remove specific commands from history
      next if $command =~ /^(ls|ll|cd|ps|top|htop|cat|less)\b/;          # general
      next if $command =~ /^(history|h|h[trwdce])\b/; # history


      # Optional Code  -- Remove Duplicate Commands
      #
      # Remove any Duplicate commands found (if timestamp is older)
      # This is recommended when merging two or more history sources.
      #
      if ( $old = $time{$command} ) {
        if ( $time > $old ) {
          # newer command has an older duplicate - remove it
          @{ $history{$old} } = grep { $_ ne $command } @{ $history{$old} }
        } else {
          # command is older than command already seen - ignore
          next;
        }
      }
      push @{ $history{$time} }, $command;  # push line into timestamp
      $time{$command} = $time;              # where to find if duplicated
    }

    # Output the merged history in timestamp, then command, order
    foreach $time ( sort {$a<=>$b} keys %history ) {
      foreach $command ( @{ $history{$time} } ) {
        print "#$time\n";
        print "$command\n";
      }
    }
  '  > "$histtmp"

  # OPTIONAL: replace current $HISTFILE with merged version
  cp "$histtmp" "$HISTFILE"

  # OPTIONAL: replace in-memry history with merged history
  history -c
  history -r "$histtmp"

  # Clean-up
  shred -u "$histtmp" || rm "$histtmp"

  unset histtmp

fi
