with Ada.Calendar;
with Ada.Text_IO;

use Ada.Calendar;
use Ada.Text_IO;

-- add packages to use random number generator

procedure cyclic_wd is
   Message    : constant String := "Cyclic scheduler with watchdog";
   -- change/add your declarations here
   Next_Time  : Time := Clock;
   d          : Duration := 1.0;
   Start_Time : Time := Clock;
   Timer_Expired : Boolean := False;

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
   begin
      Put (Message);
      Put_Line (Duration'Image (Clock - Start_Time));
      -- add a random delay here
      --  delay 1.5;  -- Simulating f3 taking longer than expected
      Timer_Expired := False;
   end f3;

   task Watchdog is
      entry Start;
      entry Stop;
   end Watchdog;

   task body Watchdog is
   begin
      loop
         select
            accept Start do
               Timer_Expired := True;
               -- Start a delay to monitor the task execution time
               delay 2.0;
               if Timer_Expired then
                  Put_Line ("Warning: f3 execution time limit exceeded.");
               end if;
            end Start;
         or
            accept Stop do
               Timer_Expired := True;
               Put_Line ("Watchdog stopped");
            end Stop;
         end select;
      end loop;
   end Watchdog;

begin
   loop
      delay until Next_Time;
      f1;
      f2;
      delay until Next_Time + 0.5;
      Watchdog.Start;
      f3;
      --  Watchdog.Stop;
      Next_Time := Next_Time + d;
   end loop;
end cyclic_wd;
