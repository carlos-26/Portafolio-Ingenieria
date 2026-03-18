MODULE Module1
    PERS tooldata Ventosa:=[TRUE,[[4.41,10.73,83.07],[0.980785,0,0,-0.19509]],[0.7,[0,0,45],[1,0,0,0],0,0,0]];
    PERS tooldata FuenteLaser:=[TRUE,[[-30.11,31,68.63],[0.980785,0,0,-0.19509]],[0.7,[0,0,45],[1,0,0,0],0,0,0]];
    PERS tooldata LaserMed:=[TRUE,[[-30.11,31,268.63],[0.980785,0,0,-0.19509]],[0.7,[0,0,43],[1,0,0,0],0,0,0]];
    VAR num Medicion:=0;
    VAR num Medicion1:=0;
    CONST num Hcaja:=19.5;
    VAR num caja1:=0;
    VAR num caja2:=0;
    VAR num caja_actual;
    VAR robtarget PLACE;
    CONST robtarget PICK:=[[34.14,182.487,42.424],[0.270598517,0.653290693,0.653271885,0.270598517],[0,-1,-2,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
    VAR robtarget PICKR:=[[0,0,0],[1,0,0,0],[0,0,0,0],[9E9,9E9,9E9,9E9,9E9,9E9]];
    CONST robtarget PLACE1:=[[120,80,0],[0,1,0,0],[0,0,-2,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
    CONST robtarget PLACE2:=[[120,200,0],[0,1,0,0],[0,0,-2,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
    CONST robtarget HOME:=[[753.98705719,91.862139212,571.260993342],[0.490392734,-0.168952938,0.84938498,-0.097545002],[0,-1,0,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];

!***********************************************************
    !
    ! Module:  Module1
    !
    ! Description:
    !   <Insert description here>
    !
    ! Author: CARTELLI
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
        !PICKR.trans:=PICK.trans;
        !PICKR.rot:=OrientZYX(90,0,180);
        !Add your code here
        LSOn;
        Fprimer_medicion;
        
        WHILE TRUE  DO
            Fpick;
            IF Cajas_en_cinta() THEN
                GOTO finalizar;
            ENDIF
            Fplace;
        ENDWHILE
        
        finalizar:
        LSOff;
        
        MoveJ HOME,v1000,fine,LaserMed\WObj:=wobj0;

    ENDPROC
    
    !La lógica requiere que haya una caja la primera vez que se mide
    PROC Fprimer_medicion()
        MoveJ PICK,v150,fine,LaserMed\WObj:=RMESA;
        Medicion:=LSMeas(\Times:=5);
        Medicion1:=Medicion;
    ENDPROC
    
    PROC Fpick()
        MoveJ PICK,v150,fine,LaserMed\WObj:=RMESA;
        Medicion:=LSMeas(\Times:=5);
                        
        IF Cajas_en_cinta() THEN
            TPWrite "No hay más cajas en la rampa";
            RETURN;
        ENDIF
                        
        MoveL PICK,v150,fine,Ventosa\WObj:=RMESA;
        Activar_ventosa;
        MoveL Offs(PICK,-30,0,30),v150,z10,Ventosa\WObj:=RMESA;
    ENDPROC
    
    PROC Fplace()
        MoveJ Offs(PLACE1,0,0,(caja1+1)*Hcaja+80),v150,z10,Ventosa\WObj:=RDEPOSITO;
        Fclasificar;
        MoveL Offs(PLACE,0,0,Hcaja*caja_actual),v150,fine,Ventosa\WObj:=RDEPOSITO;
        Desactivar_ventosa;
        MoveL Offs(PLACE,0,0,Hcaja*caja_actual*2),v150,fine,Ventosa\WObj:=RDEPOSITO;     
    ENDPROC
    
    PROC Fclasificar()
        IF Abs(Medicion - Medicion1) < 0.8 THEN
            caja1:=caja1+1;
            caja_actual:=caja1;
            PLACE:=PLACE1;
        ELSE
            caja2:=caja2+1;
            caja_actual:=caja2;
            PLACE:=PLACE2;
        ENDIF
    ENDPROC
    
    
    
    PROC Activar_ventosa()
        SetDO DO11_1, 1;
        WaitTime(0.5);
    ENDPROC
    
    PROC Desactivar_ventosa()
        SetDO DO11_1, 0;
        WaitTime(0.5);
    ENDPROC
    
    !Si hay más cajas en la cinta devolverá FALSE
    FUNC bool Cajas_en_cinta()
        IF Abs(Medicion-Medicion1) > 2.5 THEN
            RETURN TRUE;
        ENDIF
        RETURN FALSE;
    ENDFUNC
    
    
ENDMODULE