/************************************************************ 
This class is used for defining the size, location and action 
of all the buttons and menus.
*************************************************************/  

class controlSetting {
  int colorMode=0;           // Control how to color the points on the map
  int operatorSelected;
  int lineSelected;
  int vehicleSelected;
  int showLayer=0;
  int showVariable;          // Control the variable shown on the map
  int mapLayer=0;             // Control the map layer (Realtime or Accumulated)
  int frame = 5;

/************************************************************ 
Define the buttons

Code ideas reference by
https://www.processing.org/examples/button.html
https://forum.processing.org/two/discussion/558/creating-a-next-page-button
*************************************************************/  

  Button showOperator;
  Button showLine;
  Button showVehicle;

  Button buttonStart;      
  Button buttonPause;
  Button buttonReset;

  Button buttonTime;
  Button buttonSurburb;

  Button RealTime;
  Button Accumulate;

  Button buttonPrev;
  Button Next;

  Choice chooseShow;
  Choice chooseLine;
  Choice chooseVehicle;
  Choice chooseColor;
  Choice chooseFrameRate;

  controlSetting() 
  {  
    boolean timeStatus=false;
    setLayout(null);
    setButton();
    setChoice();
    setFrameRate();
  }

  void setButton()                    // Button setting including size and location
  {
    add(buttonTime=new Button("Time"));
    buttonTime.setLocation(7, 10);
    buttonTime.setSize(100, 30);
    buttonTime.setForeground(Color.red.darker());
    add(buttonSurburb=new Button("Suburb"));
    buttonSurburb.setLocation(7, 40);
    buttonSurburb.setSize(100, 30);  
    add(buttonStart= new Button("Start"));
    buttonStart.setLocation(350, 760);
    buttonStart.setSize(90, 30);
    add(buttonPause= new Button("Pause"));
    buttonPause.setLocation(450, 760);
    buttonPause.setSize(90, 30);
    add(buttonReset=new Button("Reset"));
    buttonReset.setLocation(550, 760);
    buttonReset.setSize(90, 30);   
    add(showOperator= new Button("By Operator"));
    showOperator.setLocation(35, 620);
    showOperator.setSize(130, 30);
    add(showLine= new Button("By Line"));
    showLine.setLocation(35, 650);
    showLine.setSize(130, 30);
    add(showVehicle= new Button("By Bus"));
    showVehicle.setLocation(35, 680);
    showVehicle.setSize(130, 30);
    add(RealTime=new Button("Realtime"));
    RealTime.setLocation(107, 10);
    RealTime.setSize(110, 30);
    RealTime.setForeground(Color.red.darker());
    add(Accumulate=new Button("Accumulated"));
    Accumulate.setLocation(107, 40);
    Accumulate.setSize(110, 30);
    add(buttonPrev=new Button("Prev"));
    buttonPrev.setLocation(650, 760);
    buttonPrev.setSize(90, 30);
    add(Next=new Button("Next"));
    Next.setLocation(750, 760);
    Next.setSize(90, 30);

    buttonStart.addActionListener(new ActionListener()    // Start button setting with the function 
    {
      public void actionPerformed(ActionEvent e) 
      {
        baseTimer.startTime();
      }
    }
    );   
    
    buttonPause.addActionListener(new ActionListener()    // Pause button setting with the function 
    {
      public void actionPerformed(ActionEvent e) 
      {
        baseTimer.pauseTime();
        buttonStart.setLabel("Resume");
      }
    }
    );    
   
    buttonReset.addActionListener(new ActionListener()    // Reset button setting with the function 
    {
      public void actionPerformed(ActionEvent e) 
      {
        baseTimer.initializeTime();
        buttonStart.setLabel("Start");
      }
    }
    );    
   
    buttonSurburb.addActionListener(new ActionListener()    // Suburb button setting with the function 
    {
      public void actionPerformed(ActionEvent e) 
      {       
        buttonTime.setForeground(Color.black);
        buttonSurburb.setForeground(Color.red.darker());
      }
    }
    );   
   
    buttonTime.addActionListener(new ActionListener()      // Time button setting with the function 
    {
      public void actionPerformed(ActionEvent e) 
      {
        buttonSurburb.setForeground(Color.black);
        buttonTime.setForeground(Color.red.darker());
      }
    }
    );    
   
    showOperator.addActionListener(new ActionListener()  // Operatpr button setting with the function 
    {
      public void actionPerformed(ActionEvent e) 
      {
        showLayer=0;
        showVariable=0;
        setShow();
      }
    }
    );    
   
    showLine.addActionListener(new ActionListener()      // Line button setting with the function 
    {
      public void actionPerformed(ActionEvent e) 
      {
        showLayer=1;
        showVariable=0;
        setShow();
      }
    }
    );    
    
    showVehicle.addActionListener(new ActionListener()    // Vehicle button setting with the function 
    {
      public void actionPerformed(ActionEvent e) 
      {
        showLayer=2;
        showVariable=0;
        setShow();
      }
    }
    );
    
    RealTime.addActionListener(new ActionListener()       // Realtime button setting with the function 
    {
      public void actionPerformed(ActionEvent e) 
      {
        mapLayer=0;
        Accumulate.setForeground(Color.black);
        RealTime.setForeground(Color.red.darker());
      }
    }
    );

    Accumulate.addActionListener(new ActionListener()     // Accumulate button setting with the function 
    {
      public void actionPerformed(ActionEvent e) 
      {
        mapLayer=1;
        RealTime.setForeground(Color.black);
        Accumulate.setForeground(Color.red.darker());
      }
    }
    );

    buttonPrev.addActionListener(new ActionListener()           // Prev button setting with the function 
    {
      public void actionPerformed(ActionEvent e) 
      {
          baseTimer.prevTime();
      }
    }
    );

    Next.addActionListener(new ActionListener()           // Next button setting with the function 
    {
      public void actionPerformed(ActionEvent e) 
      {
          baseTimer.nextTime();
      }
    }
    );
  }

  void setChoice()                                         // Set the choice of each button
  {
    chooseShow= new Choice();
    setShow();
    chooseShow.setLocation(35, 710);
    chooseShow.setSize(130, 30);

    chooseColor= new Choice();
    chooseColor.addItem("All Buses");
    chooseColor.addItem("Delayed");
    chooseColor.addItem("Congestion");
    chooseColor.setLocation(35, 740);
    chooseColor.setSize(130, 30);

    add(chooseShow);
    add(chooseColor);

    chooseColor.addItemListener(new ItemListener()       // Set the color of the dot in the map 
    {
      public void itemStateChanged(ItemEvent e) 
      {
        colorMode=chooseColor.getSelectedIndex();
      }
    }
    );

    chooseShow.addItemListener(new ItemListener() 
    {
      public void itemStateChanged(ItemEvent e) 
      {
        showVariable=chooseShow.getSelectedIndex();
      }
    }
    );
  }

/************************************************************    
Code ideas reference by
https://docs.oracle.com/javase/tutorial/java/nutsandbolts/switch.html
*************************************************************/  

  void setShow() 
  {
    chooseShow.removeAll();
    chooseShow.addItem("All");   
    switch(showLayer) {
    case 0: 
      for (int i=0; i<6; i++) 
      {
        chooseShow.addItem(operatorList[i]);
      }
      break;

    case 1: 
      for (int i=0; i<lineID.size (); i++) 
      {
        chooseShow.addItem(Integer.toString(lineID.get(i)));
      }
      break;

    case 2: 
      for (int i=0; i<vehicleID.size (); i++) 
      {
        chooseShow.addItem(Integer.toString(vehicleID.get(i)));
      }
      break;
    }
  }

  void setFrameRate()            // Set the frame on the map and linechart
  {
    chooseFrameRate = new Choice();
    chooseFrameRate.addItem("5");
    chooseFrameRate.addItem("10");
    chooseFrameRate.addItem("15");
    chooseFrameRate.addItem("20");
    chooseFrameRate.setLocation(250, 760);
    chooseFrameRate.setSize(90, 30);
    add(chooseFrameRate);

    chooseFrameRate.addItemListener(new ItemListener() 
    {
      public void itemStateChanged(ItemEvent e) 
      {
        frame=chooseFrameRate.getSelectedIndex();
      }
    }
    );
  }
}

