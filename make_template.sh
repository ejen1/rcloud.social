# This script generates the Pandoc template file local.template
# and fills in the $body$ template variable when a file named
# 'body.html' exists in the local directory.
#
# The script operates in two phases.  In phase one the base template
# is selected via the following rule: If a file named template.html5
# exists in the local directory then it chooses this as the base
# template otherwise it uses html/template.html5.
#
# In the second phase the script checks for the existence of a file
# named 'body.html' in the local directory.  If it exists then it
# replaces the $body$ template variable in the base template
# with the contents of 'body.html' and copies the result to
# local.template.  If 'body.html' does not exist then the
# base template is simplied copied to local.template.

if [ $# -ne 1 ]
then
    echo "Usage: make_template.sh <path>. "
    echo ""
    echo "Where <path> is the path to the 'html' folder containing the Pandoc template files."
else

    # if a file named 'template.html5' exists in the local directory
    # use it as the template source ...
    if [ -e template.html5 ]
    then
	SRC=template.html5
    else
	SRC=$1/html/template.html5 # ... otherwise use html/template.html5
    fi

    # if a file named 'body.html' exists in the local directory
    if [ -e body.html ]
    then
	OS=`uname`

	if [ ${OS} = "Darwin" ]
	then
	    sed -e "/body/r body.html" -e "/body/d" ${SRC} > local.template
	else
	    # escape the replacement target
	    key=$(echo "\$body\$" | sed -e 's/[]\/$*.^|[]/\\&/g')

	    # replate $body$ with the contents of 'body.html'
	    sed  -e "/${key}/{r body.html" -e "d}" ${SRC} > local.template
	fi
    else
	cp ${SRC} local.template  # copy the template to local.template
    fi
    
fi
