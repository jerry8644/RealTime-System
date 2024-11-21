with Ada.Calendar;
with Ada.Text_IO;

use Ada.Calendar;
use Ada.Text_IO;

-- add packages to use random number generator

procedure cyclic_wd is
   Message       : constant String := "Cyclic scheduler with watchdog";
   Next_Time     : Time := Clock;
   d             : Duration := 1.0;
   Start_Time    : Time := Clock;
   Timer_Expired : Boolean := False;
   
   task type Watchdog is
      entry Start;
   end Watchdog;

   task body Watchdog is
   begin
      accept Start;
      delay 0.5;
      if Timer_Expired then
         Put_Line ("Warning: f3 execution time limit exceeded.");
      end if;
   end Watchdog;

   type Watchdog_Ptr is access all Watchdog;




   procedure f1 is
      Message : constant String := "f1 executing, time is now";
   begin
      Put (Message);
      Put_Line (Duration'Image (Clock - Start_Time));
   end f1;

   procedure f2 is
      Message : constant String := "f2 executing, time is now";
   begin
      Put (Message);
      Put_Line (Duration'Image (Clock - Start_Time));
   end f2;

   procedure f3 is
      Message : constant String := "f3 executing, time is now";
      T1 : Watchdog_Ptr := new Watchdog;
   begin
      Put (Message);
      Put_Line (Duration'Image (Clock - Start_Time));
      Timer_Expired := True;
      T1.Start;
      delay 1.0; --TODO random time 
      T1 := null;
      Timer_Expired := False;        
   end f3;



begin
   loop
      delay until Next_Time;
      f1;
      f2;
      delay until Next_Time + 0.5;
      f3;
      Next_Time := Next_Time + d;
   end loop;
end cyclic_wd;
