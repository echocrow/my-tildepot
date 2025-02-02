function todos -a target -d "List TODOs on current branch relative to the specified branch"
	test -z "$target"; and set target 'main'
	git diff "$target" | grep -i todo -B 4 -A 4

	set gitStat $pipestatus[1]
	set grepStat $pipestatus[2]

	test $gitStat -ne 0; and return $gitStat
	test $grepStat -gt 1; and return $grepStat
	return (test $grepStat -eq 1)
end
