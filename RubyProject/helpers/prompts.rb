# Only methods for help etc..
# @author Strnadj <jan.strnadek@gmail.com>

# Help when no parameters
def print_help()
  puts <<MESSAGE
Welcome to SID - SQL Injection Detector script
\tAuthor: Strnadj <jan.strnadek@gmail.com>
\tAgreement: Only for studding purposes!

Usage:
\truby run.rb URL
\t\t--depth-level [number] - in ho many levels explore site (default 0 - undefined)
\t\t--full-domain [boolean] - explore all subdomains (default TRUE)
\t\t--output-text file - save output to text file (default nil - show output)
\t\t--error-directives [boolean] - When true error directives is set on DISPLAY_ALL (experimental, default FALSE)
MESSAGE
   # exit
   exit(1)
end