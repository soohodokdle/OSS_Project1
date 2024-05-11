#!/bin/bash

if [ "$#" -ne 3 ]; then
	echo "Usage: $0 file1 file2 file3"
	exit 1
fi

echo "************OSS1 - Project1************"
echo "*         StudentID : 12233896        *"
echo "*           Name : Yunhui So          *"
echo "***************************************"

menu_1() {
	read -p "Do you want to get the Heung-Min Son's data? (y/n): " answer
	if [ "$answer" == "y" ]; then
		cat players.csv | awk -F, '$1=="Heung-Min Son" {print "Team:"$4", Appearance:"$6", Goal:"$7", Assist:"$8""}'
		echo ""
	fi
}

menu_2() {
	read -p "What do you want to get the team data of league_position[1~20]: " answer

	cat teams.csv | awk -F, -v ans=$answer '$6==ans { winning_rate = ($2) / ($2 + $3 + $4);
	printf "%s %s %.6f", ans, $1, winning_rate;
}'
	echo ""
}

menu_3() {
	read -p "Do you want to know Top-3 attendance data (y/n) : " answer
	if [ "$answer" == "y" ]; then
		echo "***Top-3 Attendance Match***"
		echo ""
		cat matches.csv | sort -t, -r -k 2 -n | head -n 3 | awk -F, '{printf "%s vs %s (%s)\n%s %s\n\n", $3, $4, $1, $2, $7}'
	fi
}

menu_4() {
	read -p "Do you want to get each team's ranking and the highest-scoring player? (y/n) : " answer
	if [ "$answer" == "y" ]; then
		l=1
		echo ""
		while [ $l -le 20 ]
		do
			team_name=$(cat teams.csv | awk -F, -v rank=$l '$6==rank {print $1}')
			echo "$l $team_name"	
			highest_goal=$(cat players.csv | awk -F, -v team="$team_name" '$4==team {goal=$7; if (max < goal || NR == 1) max = goal} END {print max}')
			cat players.csv | awk -F, -v team="$team_name" -v high="$highest_goal" '$4==team && $7==high {print $1, high}'
			echo ""
			l=$((l+1))
		done
	fi
}

menu_5() {
	read -p "Do you want to modify the format of date? (y/n) : " answer
	if [ "$answer" == 'y' ] ; then
		cat matches.csv | sed -E 's/Jan/01/g; s/Feb/02/g; s/Mar/03/g; s/Apr/04/g; s/May/05/g; s/Jun/06/g; s/Aug/08/g; s/Sep/09/g; s/Oct/10/g; s/Nov/11/g; s/Dec/12/g;' | sed -E 's/([0-9]{2}) ([0-9]{1,2}) ([0-9]{4}) - ([0-9]{1,2}:[0-9]{2})(am|pm),.*/\3\/\1\/\2 \4\5/' | head -n 11 | tail -n 10
	       echo ""	
	fi
}

menu_6() {
	cat teams.csv | awk -F, '{teams[NR]=$1} END {for (i=1; i<=10; i++) printf "%2d) %-23s %2d) %s\n", i, teams[i+1], i+10, teams[i+11]}'
	read -p "Enter your team number : " answer

	team_name=$(cat teams.csv | awk -F, -v num=$answer 'NR==((num+1)) {print $1}')
	max=$(cat matches.csv | awk -F, -v name="$team_name" '$3==name {score=$5-$6; if (max < score || NR == 1) max = score} END {print max}')
	cat matches.csv | awk -F, -v name="$team_name" -v max_="$max" '$3==name && ($5-$6)==max_ {print ""; print $1; print $3, $5, "vs", $6, $4; print ""}' 	
}

stop="N"
until [ "$stop" = "Y" ]
do
	echo "[MENU]"
	echo "1. Get the data of Heung-Min Son's Current Club, Appearances, Goals, Assists in players.csv"
	echo "2. Get the team data to enter a league position in teams.csv"
	echo "3. Get the Top-3 Attendance matches in matches.csv"
	echo "4. Get the team's league position and team's top scorer in teams.csv & players.csv"
	echo "5. Get the modified format of data_GMT in matches.csv"
	echo "6. Get the data of the winning team by the largest difference on home stadium in teams.csv & matches.csv"
	echo "7. Exit"

	read -p "Enter your CHOICE (1~7): " menu

	case "$menu" in
	1)	menu_1 ;;
	2)	menu_2 ;;
	3) 	menu_3 ;;
	4) 	menu_4 ;;
	5) 	menu_5 ;;
	6) 	menu_6 ;;
	7) 	echo "Bye!"
		stop="Y" ;;
	esac
done
			
