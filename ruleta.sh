#!/bin/bash

# Colores
greenColour="\e[0;32m\033[1m"
endColour="\033[0m\e[0m"
redColour="\e[0;31m\033[1m"
blueColour="\e[0;34m\033[1m"
yellowColour="\e[0;33m\033[1m"
purpleColour="\e[0;35m\033[1m"
turquoiseColour="\e[0;36m\033[1m"
grayColour="\e[0;37m\033[1m"

# Ctrl+C
function ctrl_c(){
  echo -e "\n${redColour} [!] Saliendo.... ${endColour}" 
  exit 1
}
trap ctrl_c INT

function helpPanel(){
  echo -e  "${yellowColour}[+]${endColour}${grayColour} USO DE ${redColour}$0${endColour} :${endColour}\n"
  echo -e "\t${greenColour}[+] -m ${endColour}${grayColour}<Dinero con el que queremos jugar>: Introduciremos la cantidad de dinero con la que queremos jugar\n"
  echo -e "\t${greenColour}[+] -t ${endColour}${grayColour}<Tecnica con la que queremos jugar>: Introduciremos la tecnica con la que queremos jugar\n"
}

function martingala(){
  echo -e "${yellowColour}[+]${endColour}${grayColour} La cantidad de dinero actual es de --> ${greenColour}$money€${endColour}"
  echo -ne "${yellowColour}[+]${endColour}${grayColour} Que cantidad quieres apostar${endColour} ${purpleColour}-->${endColour} " && read importe_inicial 
  echo -ne "${yellowColour}[+]${endColour}${grayColour} A que quieres jugar par o impar${endColour} ${purpleColour}-->${endColour} " && read par_impar

  if [[ "$par_impar" != "par" && "$par_impar" != "impar" ]]; then
    echo -e "${yellowColour}[!]${endColour}${redColour} La jugada tiene que ser par o impar ${endColour}${yellowColour}[!]${endColour}"
    exit 1
  fi

  if [ "$importe_inicial" -gt "$money" ]; then
    echo -e "${yellowColour}[!]${endColour}${redColour} El importe inicial introducido es mayor que la cantidad de dinero que tenemos ${endColour}${yellowColour}[!]${endColour}"
    exit 1
  fi

  echo -e "${yellowColour}[+]${endColour}${grayColour} Vamos a jugar con una cantidad inicial de ${greenColour}$importe_inicial€${endColour} en ${yellowColour}$par_impar${endColour}\n" 

  tput civis
  backup_bet=$importe_inicial
  rondas_jugadas=0
  jugadas_malas=""
  while true; do
    money=$(($money-$importe_inicial))
    random_number="$(($RANDOM % 37))"
    if [ ! "$money" -lt 0 ]; then
      if [ "$par_impar" == "par" ]; then
        if [ "$(($random_number % 2))" -eq 0 ]; then
          if [ $random_number -eq 0 ]; then
            jugadas_malas+="$random_number "
          else
            reward=$(($importe_inicial*2))
            money=$(($money+$reward))
            importe_inicial=$backup_bet
            jugadas_malas=""
          fi
        else
          importe_inicial=$(($importe_inicial*2))
          jugadas_malas+="$random_number "
        fi
      else # impar
        if [ "$(($random_number % 2))" -eq 1 ]; then
          if [ $random_number -eq 0 ]; then
            jugadas_malas+="$random_number "
          else
            reward=$(($importe_inicial*2))
            money=$(($money+$reward))
            importe_inicial=$backup_bet
            jugadas_malas=""
          fi
        else
          importe_inicial=$(($importe_inicial*2))
          jugadas_malas+="$random_number "
        fi
      fi
    else 
      echo -e "\n${yellowColour}[!]${endColour}${redColour} Te has quedado sin dinero, la casa siempre gana...${endColour}${yellowColour} [!]${endColour}\n"
      echo -e "\n${yellowColour}[+]${endColour}${grayColour} Has tenido una racha de jugadas malas de${endColour} ${yellowColour}$rondas_jugadas${endColour}${grayColour} jugadas${endColour}"
      echo -e "\n${yellowColour}[+]${endColour}${grayColour} Aqui podras ver el patron de malas jugadas: \n${endColour}${blueColour}[ $jugadas_malas]${endColour}"
      tput cnorm
      exit 0
    fi
    let rondas_jugadas+=1
  done
  tput cnorm
}

function InverseLabruchere(){

    
    echo -e "${yellowColour}[+]${endColour}${grayColour} La cantidad de dinero actual es de --> ${greenColour}$money€${endColour}"
    echo -ne "${yellowColour}[+]${endColour}${grayColour} A que quieres jugar par o impar${endColour} ${purpleColour}-->${endColour} " && read par_impar
   
    if [[ "$par_impar" != "par" && "$par_impar" != "impar" ]]; then
        echo -e "${yellowColour}[!]${endColour}${redColour} La jugada tiene que ser par o impar ${endColour}${yellowColour}[!]${endColour}"
        exit 1
    fi

    declare -a my_sequence=(1 2 3 4)

    echo -e "${yellowColour}[+]${endColour}${grayColour} Empezamos con la sequencia ---> ${endColour}${blueColour}${my_sequence[@]}${endColour}"
    bet=$((${my_sequence[0]}+${my_sequence[-1]}))
    
    my_sequence=(${my_sequence[@]})
    jugadas_totales=0 
    bet_to_renew=$(($money + 50))
    tput civis

    while true; do 
        let jugadas_totales+=1 
        random_number=$(($RANDOM % 37))
        money=$(($money - $bet))

        if [ ! "$money" -lt 0 ]; then
        
          echo -e "${yellowColour}[+]${endColour}${grayColour} Invertimos ${endColour}${greenColour}$bet€${endColour}"
          echo -e "${yellowColour}[+]${endColour}${grayColour} Tenemos ${endColour}${greenColour}$money€${endColour}\n"
          echo -e "${yellowColour}[+]${endColour}${grayColour} Ha salido el numero ${endColour}${purpleColour}$random_number${endColour}"
            if [ "$par_impar" == "par" ];then
                if [ "$(($random_number % 2))" -eq 0  ] && [ $random_number -ne 0 ];then
                    echo -e "${yellowColour}[+]${endColour}${grayColour} Has gandao es par !${endColour}\n"
                    reward=$(($bet*2))
                    let money+=$reward
                    echo -e "${yellowColour}[+]${endColour}${grayColour} Tenemos un total de ${endColour}${greenColour}$money€${endColour}\n"
                    if [ $money -gt $bet_to_renew ];then
                        echo -e "${yellowColour}[+]${endColour}${grayColour} Nuestro dinero ha superado el tope${endColour}${greenColour} $bet_to_renew€${endColour} ${grayColour} estableciendo una nueva sequencia${endColour}\n"
                        let bet_to_renew+=50
                        echo -e "${yellowColour}[+]${endColour}${grayColour} Nuestro neuvo tope es${endColour}${greenColour} $bet_to_renew€${endColour}"
                        my_sequence=(1 2 3 4)
                        bet=$((${my_sequence[0]} + ${my_sequence[-1]}))
                        echo -e "${yellowColour}[+]${endColour}${grayColour} Nuestra nueva sequencia es ${endColour}${blueColour}[${my_sequence[@]}]${endColour}"
                    elif [ $money -lt $(($bet_to_renew-100)) ];then
                        echo -e "${yellowColour}[+]${endColour}${greenColour} Ha habido demasiadas perdidas reseteando el tope${endColour}"
                        let bet_to_renew-=50
                        my_sequence+=($bet)
                        my_sequence=(${my_sequence[@]})

                        echo -e "${yellowColour}[+]${endColour}${grayColour} Nuestra nueva sequencia es ${endColour}${blueColour}[${my_sequence[@]}]${endColour}\n"
                        if [ "${#my_sequence[@]}" -ne 1 ]; then
                            bet=$((${my_sequence[0]} + ${my_sequence[-1]}))
                        elif [ "${#my_sequence[@]}" -eq 1 ]; then
                            bet=${my_sequence[0]}
                        fi
                    else
                        my_sequence+=($bet)
                        my_sequence=(${my_sequence[@]})

                        echo -e "${yellowColour}[+]${endColour}${grayColour} Nuestra nueva sequencia es ${endColour}${blueColour}[${my_sequence[@]}]${endColour}\n"
                        if [ "${#my_sequence[@]}" -ne 1 ]; then
                            bet=$((${my_sequence[0]} + ${my_sequence[-1]}))
                        elif [ "${#my_sequence[@]}" -eq 1 ]; then
                            bet=${my_sequence[0]}
                        fi
                        if [ $random_number -eq 0 ];then
                        echo -e "${redColour}[!] El numero que ha salido es 0 pierdes\n${endColour}"
                        unset my_sequence[0]
                        unset my_sequence[-1] 2>/dev/null
                        fi
                        my_sequence=(${my_sequence[@]})
                        
                        echo -e "${yellowColour}[+]${endColour}${grayColour} Nuestra sequencia se va a quedar asi:${endColour}${blueColour} [${my_sequence[@]}]\n"
                        if [ "${#my_sequence[@]}" -gt 1 ]; then
                            bet=$((${my_sequence[0]} + ${my_sequence[-1]}))
                        elif [ "${#my_sequence[@]}" -eq 1 ]; then
                            bet=${my_sequence[0]}
                        else
                            echo -e "${redColour} Hemos perdido toda la sequencia, reiniciando...\n"
                            my_sequence=(1 2 3 4)
                            echo -e "${yellowColour}[+]${endColour}${grayColour} La sequencia es${endColour}${blueColour} [${my_sequence[@]}]${endColour}\n"
                        fi
                    fi
                else
                    echo -e "${redColour}[!] El numero que ha salido es impar pierdes!\n${endColour}"
                    unset my_sequence[0]
                    unset my_sequence[-1] 2>/dev/null

                    my_sequence=(${my_sequence[@]})
                    
                    echo -e "${yellowColour}[+]${endColour}${grayColour} Nuestra sequencia se va a quedar asi:${endColour}${blueColour} [${my_sequence[@]}]\n"
                if [ "${#my_sequence[@]}" -gt 1 ]; then
                    bet=$((${my_sequence[0]} + ${my_sequence[-1]}))
                elif [ "${#my_sequence[@]}" -eq 1 ]; then
                        bet=${my_sequence[0]}
                    else
                        echo -e "${redColour} Hemos perdido toda la sequencia, reiniciando...\n"
                        my_sequence=(1 2 3 4)
                        echo -e "${yellowColour}[+]${endColour}${grayColour} La sequencia es${endColour}${blueColour} [${my_sequence[@]}]${endColour}\n"
                    fi
                fi
            fi
        else
            echo -e "\n${yellowColour}[!]${endColour}${redColour} Te has quedado sin dinero, la casa siempre gana...${endColour}${yellowColour} [!]${endColour}\n"
            echo -e "\n${yellowColour}[+]${endColour}${grayColour} Has habido un total de ${endColour}${blueColour}$jugadas_totales${endColour}${grayColour} jugadas totales${endColour}\n"
            tput cnorm;exit 0
        fi
        
    done
    tput cnorm
}

# getopts
declare -i parameter=0
while getopts "m:t:h" arg; do
case $arg in
    m) money="$OPTARG";;
    t) tecnique="$OPTARG";;
    h) helpPanel; exit 1;;
  esac
done

if [ "$money" ] && [ "$tecnique" ]; then
    if [ "$tecnique" == "martingala" ]; then
    martingala
    elif [ "$tecnique" == "InverseLabruchere" ]; then 
        InverseLabruchere
    else
        echo -e "${yellowColour}[!]${endColour}${redColour} La tecnica introducida es incorrecta ${endColour}${yellowColour}[!]${endColour}"
       helpPanel
    fi
else
  helpPanel
fi
