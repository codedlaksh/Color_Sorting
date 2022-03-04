MODULE Module_cell_2
    
        CONST robtarget Home:=[[806.29,0.00,1154.00],[0.5,8.4755E-9,0.866025,4.89333E-9],[0,0,0,0],[9E+9,9E+9,9E+9,9E+9,9E+9,9E+9]];
    CONST robtarget PickABove:=[[-877.47,-904.21,763.34],[0.0149837,-0.00788759,-0.999624,0.0215762],[-2,0,-2,0],[9E+9,9E+9,9E+9,9E+9,9E+9,9E+9]];
    CONST robtarget PickObj:=[[-845.8421,-765.8145,532.1487],[0.0005568208,0.0630753,0.7042878,-0.7071067],[-2,1,-3,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
    CONST robtarget DropYellow:=[[984.764,-2.392461,902.2894],[0.5223812,-0.4765688,0.5223813,-0.4765688],[-1,-1,-1,1],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
    CONST robtarget DropRed:=[[984.764,-203.3255,902.2894],[0.5223812,-0.4765688,0.5223813,-0.4765688],[-1,-1,-1,1],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
    CONST robtarget DropBad:=[[984.764,218.4375,902.2894],[0.5223813,-0.4765687,0.5223814,-0.4765687],[0,0,-2,1],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];

    PROC main()

               PPNP_Home;!To check if PPNP Robot is at home position

        ABB_Home;!To check if ABB Robot is at home position

        Request_Part;!To request next part/item

        WaitDI DI9, 1; !To check if part is present on conveyor

        PPNP_Seq;!To execute the PPNP sequence to pick a part from conveyor and to place it in a spring stand, so that Robot can pick the piece from spring stand

        ABB_PNP;!Robot will pick the item from spring stand and place it in one of the boxes based on the color condition

        ABB_Home;! Robot back to home position

ENDPROC

 

PROC PPNP_Home()

        If DI8 = 1 THEN

        CYL_UP;

        CYL_SWIN;

        CYL_RET;

        CYL_GRPOF;

        ENDIF

        WaitDI DI8, 0;

ENDPROC

 

PROC ABB_Home()      

        MoveJ Home, v1000, Fine, tool0;

        WaitDI DI16,1;

ENDPROC  

  

PROC Request_Part()

    PulseDO DO14; ! Read next color

   PulseDO DO13; ! Index Conveyor

ENDPROC

 

PROC PPNP_Seq()

        CYL_DWN;

        CYL_EXT;

        CYL_GRPON;

        CYL_UP;

        CYL_RET;

        CYL_SWOUT;

        CYL_EXT;

        CYL_DWN;

        CYL_GRPOF;

        CYL_UP;

        CYL_RET;

        CYL_SWIN;

ENDPROC

 

PROC CYL_UP()

        Reset DO9;
        
        WaitTime 1;

ENDPROC

 

PROC CYL_DWN()

        

        Set DO9;

        WaitTime 1;

ENDPROC

 

PROC CYL_SWOUT()

      

        Set DO10;

        WaitTime 1;

ENDPROC

 

PROC CYL_SWIN()

        Reset DO10;
      
        WaitTime 1;

ENDPROC

 

PROC CYL_EXT()

        

        Set DO11;

        WaitTime 1;

ENDPROC

 

PROC CYL_RET()

        Reset DO11;

       

        WaitTime 1;

ENDPROC

      

PROC CYL_GRPON()

        Set DO12;

        WaitTime 1;

ENDPROC

 

PROC CYL_GRPOF()

       Reset DO12;

        WaitTime 1;

ENDPROC

 

PROC ABB_PNP()

    WaitDI DI14,1; !Part present on spring stand

    ABB_Pick;

    IF DI10=1 AND DI11=0 THEN

        Yellow_Part;

    ELSEIF DI10=0 AND DI11=1 THEN

            Red_Part;

    ELSE

            Bad_Part;

    ENDIF

ENDPROC

 

PROC ABB_Pick()

        MoveJ Offs (PickObj,0,0,100), V1000, z0, tool0;

        If DO5 <> 0 Open_Gripper;

        WaitDO DO5, 0;

        MoveL PickObj, v500, Fine, tool0;

        Close_Gripper;

        MoveJ Offs (PickObj,0,0,100), V1000, z0, tool0;

ENDPROC  

 

PROC Open_Gripper()

        Reset DO5;

        WaitTime 1;

ENDPROC

 

PROC Close_Gripper()

        Set DO5;

        WaitTime 1;

ENDPROC

 

PROC Yellow_Part()

    MoveJ DropYellow, v1000, FINE, tool0;

    MoveL Offs(DropYellow,0,0,-50), v500, fine, tool0;

    Open_Gripper;

ENDPROC

 

PROC Red_Part()

    MoveJ DropRed, v1000, FINE, tool0;

    MoveL Offs(DropRed,0,0,-50), v500, fine, tool0;

    Open_Gripper;

ENDPROC

 

PROC Bad_Part()

    MoveJ DropBad, v1000, FINE, tool0;

    MoveL Offs(DropBad,0,0,-50), v500, fine, tool0;

    Open_Gripper;

ENDPROC

          



ENDMODULE