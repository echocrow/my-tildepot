function mtime --description "Print the modification timestamp of a file"
	stat -f '%m' $argv
end
