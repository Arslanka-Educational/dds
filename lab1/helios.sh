set -o errexit
cd $(dirname -- $0)

print() {
  YC="\033[1;34m" # Yes Color
  NC="\033[0m"    # No Color
  printf "$YC[ddb] $1$NC\n"
}

run() {
  print "Running SQL script: $1..."
  psql -h pg -d studs -f $1
}

print "Starting defending the 1st lab solution..."

run initialize.sql
run get_table_info.sql

print "Done!"
