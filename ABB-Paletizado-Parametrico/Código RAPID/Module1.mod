MODULE Module1
    !!!!! USAR MAYUSCULAS PARA LAS CONSTANTES
    PERS tooldata Sopapa:=[TRUE,[[0,-5,103],[1,0,0,0]],[0.5,[0,0,40],[1,0,0,0],0,0,0]];
    PERS tooldata Sopapa_caja:=[TRUE,[[0,-5,118],[1,0,0,0]],[0.5,[0,0,40],[1,0,0,0],0,0,0]];
    CONST robtarget PPICK:=[[300,32.5,135],[0,1,0,0],[0,0,0,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
    CONST robtarget PPLACE1:=[[32.5,65,0],[0,-0.707106781,0.707106781,0],[0,0,0,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
    CONST robtarget HOME:=[[595.492267836,-5,628],[0.5,0,0.866025404,0],[0,-1,0,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
    CONST num cant_cajas:=9;
    CONST num h_caja:=15;
    CONST num dx_PPLACE1:=130;
    VAR num CajasEnPalet:=0;

    !***********************************************************
    !
    ! Module:  Module1
    !
    ! Description:
    !   <Insert description here>
    !
    ! Author: CARLOS ISAAC
    !
    ! Version: 1.0
    !
    !***********************************************************
    
    
    !***********************************************************
    !
    ! Procedure main
    !
    !   This is the entry point of your program
    !
    !***********************************************************
    PROC main()
        !Add your code here 
        VAR num pila:=0; !indica la pila actual de paletizado iniciando en 0
        VAR num caja_pilai:=0; !Contador de cajas en la pila i comienza en 0
        VAR num CajaEnPalet:=0;
        
        !FOR i FROM 0 TO cant_cajas-1 DO
        !   IF i MOD 3 = 0 AND i <> 0 THEN
        !        pila := pila +1; !cambio a la pilai
        !        caja_pilai:=0; !reinicio el contador de caja pues empiezo nueva pila
        !    ENDIF
        !    Pick(i*h_caja);
        !    Armar_pila(pila),(caja_pilai);
        !    caja_pilai:=caja_pilai + 1;
        !    CajasEnPalet := CajasEnPalet+1;
        !ENDFOR
        
        WHILE CajasEnPalet < cant_cajas DO
            IF CajasEnPalet MOD 3 = 0 AND CajasEnPalet <> 0 THEN
                pila := pila + 1;        ! Cambio a la pila siguiente
                caja_pilai := 0;         ! Reinicio el contador de cajas en la nueva pila
            ENDIF

            Pick(CajasEnPalet * h_caja);
            Armar_pila pila, caja_pilai;

            caja_pilai := caja_pilai + 1;
            CajasEnPalet := CajasEnPalet + 1;
        ENDWHILE 
            
        !ENDWHILE
        
        MoveJ HOME,v100,fine,Sopapa\WObj:=wobj0;
    ENDPROC
    
    !Va variando la altura z donde busca la caja
    PROC Pick(num z)
        MoveJ Offs(PPICK, 0,0,30),v100,z10,Sopapa\WObj:=RMESA;
        MoveL Offs(PPICK,0,0,-z),v100,fine,Sopapa\WObj:=RMESA;
        SetDO DO_SOPAPA, 1;
        WaitTime(1);
        MoveL Offs(PPICK, 0, 0, 30),v100,z10,Sopapa\WObj:=RMESA;
    ENDPROC
    
    
    PROC Place(robtarget PPLACE, pos offset_PPLACE)
        MoveJ Offs(PPLACE, offset_PPLACE.x,offset_PPLACE.y,offset_PPLACE.z),v100,z10,Sopapa_caja\WObj:=RPALET;
        
        MoveL PPLACE,v50,fine,Sopapa_caja\WObj:=RPALET;
        SetDO DO_SOPAPA, 0;
        WaitTime(1);
        MoveL Offs(PPLACE,0,0,30),v100,z10,Sopapa\WObj:=RPALET;
    ENDPROC
    
    
    PROC Armar_pila(num pila, num caja_pilai)
        VAR num z;
        VAR robtarget PPLACE;
        VAR orient rotacion_place;
        !Desplazamientos respecto de PPLACE1 para pila tipo 1 (pila par)
        !VAR num d01{3} := [97.5,32.5,0]; !definirlo en funcion de dimensiones de la caja
        !VAR num d02{3} := [97.5,-32.5,0];
        VAR pos d01:=[97.5,32.5,0];
        VAR pos d02:=[97.5,-32.5,0];
        !Orientacion respecto RPALET para pila tipo 1 (pila par)
        VAR orient o1;
        VAR orient o2;
        !Offset de aproximación a PPLACE
        VAR pos offset_PPLACE := [0,0,30]; !El que es por defecto para PPLACE1
        !Para pila tipo 1 (par) offset para cada caja 1 y 2
        !VAR num offset_PPLACE_1{3} := [30,0,30];
        !VAR num offset_PPLACE_2{3} := [30,-30,30];
        VAR pos offset_PPLACE_1:=[30,0,30];
        VAR pos offset_PPLACE_2:=[30,-30,30];

        
        z := pila*h_caja;        
        PPLACE:=Offs(PPLACE1,0,0,pila*h_caja); !Inicio la variable place y le doy la altura de la pila
        rotacion_place:=OrientZYX(90,0,180);
        o1:= OrientZYX(0,180,0); 
        o2:= OrientZYX(0,0,180);
        
        IF pila MOD 2 <> 0 THEN !pila impar modifico a a otra forma
            PPLACE:=Offs(PPLACE,dx_PPLACE1,0,0);
            PPLACE.rot:=rotacion_place; !creo que esta tmb es correcta y queda mejor calcularla así
            !PPLACE.rot:=[0,0.707106781,0.707106781,0]; !Orientación correcta verificada
            d01 := [-97.5,-32.5,0];
            d02 := [-97.5,32.5,0];
            o1:=OrientZYX(0,0,180);
            o2:=OrientZYX(0,180,0);
            offset_PPLACE_1 := [-30,0,30];
            offset_PPLACE_2 := [-30,30,30];
        ENDIF
        
        IF caja_pilai = 1 THEN
            PPLACE:=Offs(PPLACE,d01.x,d01.y,d01.z);
            PPLACE.rot:=o1;
            offset_PPLACE := offset_PPLACE_1;
        ELSEIF caja_pilai = 2 THEN
            PPLACE:=Offs(PPLACE,d02.x,d02.y,d02.z);
            PPLACE.rot:=o2;
            offset_PPLACE := offset_PPLACE_2;
        ENDIF
        
        Place(PPLACE),(offset_PPLACE);
    ENDPROC
ENDMODULE