#! /bin/csh -f

set team_list = (   勇士\
                    鵜鶘\
                    火箭\
                    爵士\
                    騎士\
                    暴龍\
                    76\
                    提克\
)

set count_iter = 0
@ i = 1
foreach x ( $team_list )
    if ($i == 1) then 
        set stringList = "yes_$x"
    else
        set stringList = "no_$x"
    endif
    echo $stringList
    echo $i
    @ i += 5
end

@ i = 1
while ($i <= 20)
  ... body ...
  @ i += 5
end
