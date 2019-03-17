#!/bin/bash
# command line parsing from example:
# https://stackoverflow.com/a/14203146

# A POSIX variable
OPTIND=1         # Reset in case getopts has been used previously in the shell.

show_help(){
    echo usage $0 -i instance-name-tag where one must have set up an
    echo AWS instance with a tag with Name name and value is some name
}


while getopts "h?i:" opt; do
    case "$opt" in
    h|\?)
        show_help
        exit 0
        ;;
    i)  instance_name=$OPTARG
        ;;
    esac
done

shift $((OPTIND-1))

[ "${1:-}" = "--" ] && shift

echo "instance_name=$instance_name, , Leftovers: $@"

[ -z "$instance_name" ] && show_help && exit  0

aws ec2 start-instances --instance-id=$(aws ec2 describe-instances --filter Name=tag:name,Values=${instance_name} --query='Reservations[*].Instances[*].[InstanceId]' --output text)
