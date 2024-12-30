#!/bin/bash

RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'

# Test 1: ./philo 4 410 200 200 => No philosopher should die
echo "Test 1: ./philo 4 410 200 200 => No philosopher should die"
./philo 4 410 200 200 > output.txt 2>&1 &
pid=$!

for i in {1..10}; do
    echo -ne "Loading... ${i}0% \r"
    sleep 1
done
echo -ne '\n'

if ps -p $pid > /dev/null; then
    kill $pid
    echo -e "${GREEN}OK${NC}"
else
    echo -e "${RED}KO${NC}"
fi

# Test 2: ./philo 5 800 200 200 => No philosopher should die
echo "Test 2: ./philo 5 800 200 200 => No philosopher should die"
./philo 5 800 200 200 > output.txt 2>&1 &
pid=$!

for i in {1..10}; do
    echo -ne "Loading... ${i}0% \r"
    sleep 1
done
echo -ne '\n'

if ps -p $pid > /dev/null; then
    kill $pid
    echo -e "${GREEN}OK${NC}"
else
    echo -e "${RED}KO${NC}"
fi

# Test 2.1: ./philo 200 410 200 200 => No philosopher should die
echo "Test 2.1: ./philo 200 410 200 200 => No philosopher should die"
./philo 200 410 200 200 > output.txt 2>&1 &
pid=$!

for i in {1..10}; do
    echo -ne "Loading... ${i}0% \r"
    sleep 1
done
echo -ne '\n'

if ps -p $pid > /dev/null; then
    kill $pid
    echo -e "${GREEN}OK${NC}"
else
    echo -e "${RED}KO${NC}"
fi 

# test 2.2 : Test 2.2: ./philo 199 610 200 200 => No philosopher should die
echo "Test 2.2: ./philo 199 610 200 200 => No philosopher should die"
./philo 199 610 200 200 > output.txt 2>&1 &
pid=$!

for i in {1..10}; do
    echo -ne "Loading... ${i}0% \r"
    sleep 1
done
echo -ne '\n'

if ps -p $pid > /dev/null; then
    kill $pid
    echo -e "${GREEN}OK${NC}"
else
    echo -e "${RED}KO${NC}"
fi

# Test 3: One philosopher should die
echo "Test 3: ./philo 4 310 200 100 => One philosopher should die"
./philo 4 310 200 100 > output.txt 2>&1 &
pid=$!

died=false
for i in {1..10}; do
    echo -ne "Loading... ${i}0% \r"
    sleep 1
    if grep -q "died" output.txt; then
		died=true
		break
    fi
done
echo -ne '\n'
if [ "$died" = true ]; then
	echo -e "${GREEN}OK${NC}"
else
	echo -e "${RED}KO${NC}"
fi
kill $pid 2>/dev/null


# Test 4: One philosopher should die
echo "Test 4: ./philo 5 600 200 100 => One philosopher should die"
./philo 5 600 200 100 > output.txt 2>&1 &
pid=$!

died=false
for i in {1..10}; do
    echo -ne "Loading... ${i}0% \r"
    sleep 1
    if grep -q "died" output.txt; then
		died=true
		break
    fi
done
echo -ne '\n'
if [ "$died" = true ]; then
	echo -e "${GREEN}OK${NC}"
else
	echo -e "${RED}KO${NC}"
fi
kill $pid 2>/dev/null

echo "Test 5: ./philo 100 410 200 200 => Data race check with valgrind DRD"
valgrind --tool=drd ./philo 100 410 200 200 > drd_output.txt 2>&1 &
pid=$!

for i in {1..20}; do
    echo -ne "Loading... ${i}s \r"
    sleep 1
done
echo -ne '\n'

if grep -q "Conflicting" drd_output.txt; then
    echo -e "${RED}KO - Data races detected${NC}"
else
    echo -e "${GREEN}OK - No data races detected${NC}"
fi
kill $pid 2>/dev/null


echo "Test 6: ./philo 100 610 200 200 => Data race check with valgrind DRD"
valgrind --tool=drd ./philo 150 610 200 200 > drd_output.txt 2>&1 &
pid=$!

for i in {1..20}; do
    echo -ne "Loading... ${i}s \r"
    sleep 1
done
echo -ne '\n'

if grep -q "Conflicting access" drd_output.txt; then
    echo -e "${RED}KO - Data races detected${NC}"
else	
    echo -e "${GREEN}OK - No data races detected${NC}"
fi
kill $pid 2>/dev/null

rm -f drd_output.txt output.txt
