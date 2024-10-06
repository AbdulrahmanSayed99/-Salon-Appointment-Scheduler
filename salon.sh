#!/bin/bash
PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"
echo -e "\n~~~~~ MY SALON ~~~~~\n"

echo -e "\nWelcome to My Salon, how can I help you?"
SERVICES=$($PSQL "SELECT service_id, name FROM services ORDER BY service_id")
MAIN_MENU() { 
  if [[ $1 ]] 
  then
    echo -e "\n$1"
  fi
  
  echo  "$SERVICES" | while read SERVICE_ID SERVICE_NAME
do
echo  "$SERVICE_ID) $SERVICE_NAME" | sed 's/ |//'
done
read SERVICE_ID_SELECTED
  case  $SERVICE_ID_SELECTED  in
  1) SERVICE 1 ;;
  2) SERVICE 2 ;;
  3) SERVICE 3 ;;
  4) SERVICE 4 ;;
  5) SERVICE 5 ;;
  *) MAIN_MENU "I could not find that service. What would you like today?";;
esac
}
SERVICE (){
  echo -e "\nWhat's your phone number?"
  read CUSTOMER_PHONE
  CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone='$CUSTOMER_PHONE'")
  if [[ -z $CUSTOMER_NAME ]]
  then
  echo -e "\nI don't have a record for that phone number, what's your name?"
  read CUSTOMER_NAME
INSERT_CUSTOMER_RESULT=$($PSQL "INSERT INTO customers(phone, name) VALUES('$CUSTOMER_PHONE', '$CUSTOMER_NAME')")
  fi
  SELECTED_SERVICE=$($PSQL "SELECT name FROM services WHERE service_id= $1")
  echo -e "\nWhat time would you like your $SELECTED_SERVICE, $CUSTOMER_NAME?"
  read SERVICE_TIME
  echo -e "I have put you down for a $SELECTED_SERVICE at $SERVICE_TIME, $CUSTOMER_NAME."
  CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone= '$CUSTOMER_PHONE'")
  INSERT_APPOINTMENT_RESULT=$($PSQL "INSERT INTO appointments(customer_id, service_id, time) VALUES($CUSTOMER_ID, $1, '$SERVICE_TIME')")
}

MAIN_MENU