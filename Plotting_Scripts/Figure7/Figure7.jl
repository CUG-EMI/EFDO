using GMT  

gmtbegin("Figure7_jl", fmt="pdf,png")  
   
    basemap(  
    region=[0, 500, 0.001, 1.0], figsize=(10, 7), proj=:logy,  
    frame=(axes=:WStr,),  
    xaxis=(annot=100, label=:"Epoch"),   
    yaxis=(annot=1, ticks=3, label=:"Relative loss", scale=:pow),  
    par=(FONT_ANNOT_PRIMARY=10, FONT_LABEL=12, MAP_FRAME_PEN=0.6)   
    )  

    # U-FNO 
    plot!("data1_train.txt", pen=(0.6, "0/83/156"),legend="U-FNO train")     
    plot!("data1_val.txt", pen=(1.3, "65/105/225,.."),legend="U-FNO val")     
    plot!("data1_test.txt", pen=(0.4, "30/144/255,--"),legend="U-FNO test")    

    # EFDO  
    plot!("data2_train.txt", pen=(0.6, "178/34/34"),legend="EFDO train")     
    plot!("data2_val.txt", pen=(1.3, "220/20/60,.."),legend="EFDO val")       
    plot!("data2_test.txt", pen=(0.4, "255/99/71,--"),legend="EFDO test")     

    # EFNO  
    plot!("data3_train.txt", pen=(0.6, "0/100/0"),legend="EFNO train")        
    plot!("data3_val.txt", pen=(1.3, "34/139/34,.."),legend="EFNO val")      
    plot!("data3_test.txt", pen=(0.4, "60/179/113,--"),legend="EFNO test")    
    
    gmtset(FONT_ANNOT_PRIMARY=10, FONT_LABEL=14, MAP_FRAME_PEN=0.3)  
    # add legend  
    gmtset(FONT=7,)
    legend!(position=(anchor=:TR, width=2.2, offset=0.1),   
           box=(pen=0.3, fill=:white, radius=0.1))  

gmtend()