• Project_4_model.slx - Simulink model that takes the fully models an elcectric drive car around a banked oval track 
                        while modeling the cars state of charge to be within a certain threshold. Goal is to have the car
			navigate track as many times as possible within 60 minutes. Vehicle is modeled with a 3 speed transmission. 


  • Driver - uses three functions to calculate the steering angle based on the 'pure pursuit' method
        
	  • Determine Velocity fcn - based on location of the track, will change desired vx (faster on straights)

	  • Desired Heading/Bank Angle fcn
		• Returns psi desired based on lookahead distance (Has an adjustment factor to eliminate discontinuity after 2pi)

		• Return Curvature to be used in next block

		• Returns Bank Angle based on closest location on track

	  • Steering Angle
	
		• Takes in e (psi - psi_d), curvature, and distance from centerline and returns delta

		• Our adjustment factors are based on distance from centerline (if it's close then no need to use e which can cause oscillations)

		• Tuned to our specific speed and vehicle setup
	    
    • Vehicle Model- Combines all dynamic systems within the vehicle including the electric motor, tire forces, 
    		     battery state of charge, brakes, and drivetrain in order to find net acceleration on the vehicle and plot 
	   	     the vehicle's position as it goes around the track during the simulation.
	  
	  • Throttle and Braking subsystem - determines the accelerator and braking percentage (APP and BPP) 
                                             based on the desired and actual speeds, battery state of charge, bus voltage, 
					     and motor angular velocity.
	  
	        • The first function calculates the acceleration and braking proportions 
	            based on the comparison between actual and desired speeds. 
	            Proportions have upper and lower limits of (1, 0) for acceleration 
	            and (0, -1) for braking.
		• The 2nd function calculates APP, BPP and the regenerative braking 
	            proportions where regen is 0 for low speeds (less than 5 mph) and 0.95 
	            for higher speeds (>= 25 mph). APP is a function of a, b, and the regen 
	            factor and BPP is a function of b and the friction factor which is 1 - regen. 
	        • The overall regenerative braking is then calculated based on a 2-D torque 
	            lookup table and a 2-D efficiency lookup table. The regen factor is then 
	            multiplied by the max regen torque and efficiency to calculate the overall 
	            regenerative braking factor.
    
	    • Electric Motor Drive  - Contains the battery, inverter, and motor subsystems. 
	
	        • Inverter - Calculates battery current and bus voltage using battery efficiency values
	        
	        • Battery -  System models battery and cell performance and outputs the battery voltage
		             And power and energy loss of the battery
	       
	            • Cell Current -  Calculates current per cell using the number of parallel cells in a bus  
	            
	            • State of Charge - Integrates the current of a cell and inputs the number of parallel cells 
			                Cell capacity to output battery state of charge. Starts at 0.8 SOC but can go above that using regen braking.
	  
	            • Battery Voltage and Power Loss- Calculates the total battery voltage and power loss 
	                                              within the battery using open circuit voltage and battery properties
	
	        • Electric motor -  Models the electric motor drive. Inputs are the radial velocity of the motor,
	                        	 the battery voltage, and the accelerator pedal position. 
	                           Uses look-up tables to collect motor performance at different conditions. 
	                           Outputs motor power, energy, and bus current.
	
	            • Electric Motor - Uses tau and efficiency of the electric motor from lookup tables with the
			              bus voltage to output the power provided by the motor and the bus current.
	
	    • Drive Train - Converts the motor outputs to wheel inputs using the input gear ratio which
		            is a 3 speed transmission. Gears are decided upon using if statements and velocity thresholds
	      
	    • TireSlip fcn - calculates the front and rear tire slip angles and sends outputs through saturation function 
        
	    • TireForces fcn - calculates the forces in y generated from the tires based on the tire slip angles as well as the moment ab CG
		
	    • Brakes - Uses brake pedal position and max braking torque to get braking torque.
		             Output is checked to prevent braking from exceeding wheel torque at 0 velocity.
	        
	    • Wheel forces- Wheel frame force calculations in the longitudinal direction. Outputs force from
		           drag, braking, and throttling along with wheel rotational speed.
	     
	    • Wheel Speed and Acceleration - vehicle velocity and wheel radius are taken as inputs to find the wheel's 
     				    	    angular velocity.
	
	    • Vehicle Dynamics - Calculates the acceleration of vehicle in x and y as well as the angualr acceleration of the vehicle.

	    • CarBodyFrame(KinematicInertial) Subsystem- Converts from car frame to global frame
	
	    • XY Graph - plots the car's x- and y-position from the CarBodyFrame(KinematicInertial) Subsystem

    
Structure:

    •   p4_init file includes car, battery, and motor specific data. Car data includes constants for vehicle dynamics functions 
    	which can be editied for a faster vehicle and lap time. Motor has arrays of torque, speed, efficiency, and vbus values 
     	to be used in look up tables in the vehicle model simulink subsystem. Values given in class remain the same but additional info is added.
   
    • plot_track.m - runs the simulation and will plot track with animation and store data in workspace (car size not to scale)

    • generate_track.m - intitializaiton file that creates target line, boundaries, and banking and adds to track structure

    • raceStat.m - takes inputs of X, Y, Time, and track_data to calculate and output laps_completed, total_laps, lap_times, 
    		   total_time, and out_of_bounds

    • create_car_vertices.m - takes global position, psi, and length and width of the car as input and outputs the coordinates 
    			      of each vertex to allow for iterative plotting in the animation

    
