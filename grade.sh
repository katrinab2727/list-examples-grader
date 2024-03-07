
CPATH='..:..lib/hamcrest-core-1.3.jar:lib/junit-4.13.2.jar'

rm -rf student-submission
rm -rf grading-area

mkdir grading-area

git clone $1 student-submission
echo 'Finished cloning'

if [[ -f student-submission/ListExamples.java ]] 
then
    cp student-submission/ListExamples.java grading-area/
    cp TestListExamples.java grading-area/
    cp -r lib grading-area
    echo "File found"
else
    echo "File ListExamples.java not found!"
    exit 1
fi 

cd grading-area
javac -cp $CPATH *.java

if [ $? -ne 0 ] 
then
    echo "Compilation error!"
    exit 1
fi

# java -cp $CPATH org.junit.runner.JUnitCore TestListExamples > juni-output.txt
echo "Program complied successfully"


java -cp $CPATH org.junit.runner.JUnitCore TestListExamples > junit-output.txt

lastline=$(cat junit-output.txt | tail -n 2 | head -n 1)
tests=$(echo $lastline | awk -F'[, ]' '{print $3}')
failures=$(echo $lastline | awk -F'[, ]' '{print $6}')
successes=$((tests - failures))
score=$((successes/tests))

echo "You passed $successes out of $tests tests"
echo "Your score is $score %"

# if grep -q "FAILURES!!!" junit-output.txt; then
    # echo "Tests failed. Grade: 0"
#else
#    echo "All tests passed. Grade 100"
#fi
