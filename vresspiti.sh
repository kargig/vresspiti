#!/bin/bash

#Variables
RECIPIENTS="youremail@address.com,andonemore@newaddress.com"
WORK_PATH="/home/yourusername/myhouses"
URL="http://www.xe.gr/property/search?System.item_type=re_residence&Transaction.type_channel=117541&Transaction.price.from=300&Transaction.price.to=500&Item.area.from=40&Item.area.to=100&Geo.area_id_new__hierarchy=83268"
USER_AGENT="User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101 Firefox/68.0"

#cleanup
rm -f ${WORK_PATH}/tmp/array.out
rm -f ${WORK_PATH}/tmp/tomail
rm -f ${WORK_PATH}/tmp/newout

mkdir -p "${WORK_PATH}/tmp"

curl "${URL}" -H "${USER_AGENT}" | pup '[class="r_desc"] json{}' > ${WORK_PATH}/tmp/newout
jq -r '[.[] as $house | [$house.children[0].children[0].href,$house.children[1].text]]' < ${WORK_PATH}/tmp/newout| \
	sed -e 's/"//g' | sed -e 's/\(\/pro\)/https:\/\/www.xe.gr\1/g'         | \
	sed -e 's/],*//g' -e 's/\[//g' -e '/^\s*$/d' -e 's/,$//g' -e 's/^\s*//g' \
	> ${WORK_PATH}/tmp/array.out

IFS=$'\r\n' GLOBIGNORE='*' command eval  'HOUSES=($(cat ${WORK_PATH}/tmp/array.out))'
ARRLEN=${#HOUSES[@]}

i=0
while [ "${i}" -lt "${ARRLEN}" ]; do
	# get the links for the houses, string must contain http
	echo "${HOUSES[$i]}" | grep -q "http"
	if [ "$?" -eq "0" ]; then
		# filter out houses that we have already sent email for
		grep -q "${HOUSES[$i]}" ${WORK_PATH}/mailed
		if [ "$?" -gt "0" ]; then
			# only continue if the description of the house doesn't contain "κεντρικ. θ.ρμανση"
			echo "${HOUSES[$((i+1))]}" | egrep -q "κεντρικ. θ.ρμανση"
			if [ "$?" -gt "0" ]; then
				echo "New house ${HOUSES[$i]}" >> ${WORK_PATH}/tmp/tomail
				echo "${HOUSES[$((i+1))]}" >> ${WORK_PATH}/tmp/tomail
			fi
		fi
	fi
	i=$(( i + 1 ))
done


if [ -f ${WORK_PATH}/tmp/tomail ]; then
	mailx -s "new houses" -r noreply@xe.gr ${RECIPIENTS} < "${WORK_PATH}"/tmp/tomail
	grep http ${WORK_PATH}/tmp/tomail >> ${WORK_PATH}/mailed
	rm -f ${WORK_PATH}/tmp/tomail
fi
