MODULE LS(NOSTEPIN)
  ! VERSION 0 : primera version operativa de modulo de medicion por laser
  ! el sensor laser debe estar conectado al robot y:
  !    - la entrada analogica originalmente denominada AI10_4 renombrada como AI_LS
  !    - la salida digital originalmente denominada DO11_3 renombrada como DO_SON
  ! Módulo de control del sensor laser de distancia
  ! Este módulo permite encender, medir con distintas opciones y apagar el laser
  ! Las rutinas visibles para el usuario son: 
  ! LSMeas
  !      medicion:= LSMeas(\Times:= , \TurnOff)
  !      \Times:= cantidad de veces a medir y promediar, \TurnOn \TurnOff para enceder y o apagar el sensor antes o luego de la medicion
  ! IsLSOn
  ! LSOn
  ! LSOff

  ! la entrada analógica esta mapeada y modificada desde el RAPID para entregar valores del span del sensor (-80 +80) en forma directa 
  !
  ! PINOUT FICHA
  ! Ficha macho: lado sensor
  ! GND
  ! PIN 1: Ai Laser, entrada analógica de medición	: AI_LS
  ! PIN 2: DO encendido/alimentación sensor			: DO_SON
  ! PIN 3: Di entrada digital (desde sensor)		: DI_SIN
  ! PIN 4: Ai aux, desde el sensor inductivo		: AI_IS
  !
  !                   **  **
  !                ************
  !              ****************
  !             ** 4 o **** o 3 **
  !             ******************
  !             ** 2 o **** o 1 **
  !             ******************
  !                ****[==]****
  !                   ******
  

  ! constantes de medicion de laser	
  CONST num LS_MAXVALUE:=82;
  CONST errnum ERR_LSOUTOFRNG:=77;
  LOCAL CONST num DELAY_PWR:=2;
  LOCAL CONST num DELAY_TIMES:=0.05;
  
  FUNC num LSMeas(
    \num Times
    \switch TurnOff)
	VAR num value:=0;
    VAR num suma:=0;
    LSOn;
    IF Present(Times) THEN
      FOR i FROM 1 TO Times DO
        suma:=suma+AI_LS;
        WaitTime DELAY_TIMES;
      ENDFOR
      value:=suma/Times;
    ELSE
      value:=AI_LS;
    ENDIF
    IF Present(TurnOff) LSOff;
    IF value>LS_MAXVALUE RAISE ERR_LSOUTOFRNG;
      !RETURN -9E+09;
      ! fuera de rango
    RETURN value;
    ERROR
        IF ERRNO=ERR_LSOUTOFRNG RAISE;
  ENDFUNC

  
  FUNC bool IsLSOn ()
  	IF DOutput(DO_SON)=0 THEN 
  		RETURN FALSE;
  	ELSE
  		RETURN TRUE;
  	ENDIF
  ENDFUNC
    
  
  PROC LSOn() ! si el laser está ya encendido no hace nada
    IF NOT IsLSOn() THEN 
    	SetDO DO_SON,1;
    	WaitTime DELAY_PWR;
    ENDIF
    ! sino no hacer nada, porque el laser ya está encendido
  ENDPROC

  PROC LSOff()
    SetDO DO_SON,0;
  ENDPROC

ENDMODULE