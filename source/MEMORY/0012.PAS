Unit Oversize;

{  Author:  Trevor J Carlsen
            Algorithm Enterprises Pty Ltd
            PO Box 568
            Port Hedland  6721
            Western Australia
            Telephone:  (Voice)  +61 [0]91 73 2026
                        (Data )  +61 [0]91 73 2569
                        
  Released into the Public Domain 1991.

  An Unit that will enable logical Arrays to be created using up to the amount 
  of heap memory available.

  The line marked (**) MUST be altered to reflect the Type of data in big 
  Array and the Unit MUST be reCompiled after this change.

  No provision is made in this Unit For recovering the memory used by the big 
  Array as the intention was to keep it appearing to the Programmer as close 
  as possible to static Type global Variables.

  Bear in mind that you do not declare your Array anywhere using this Unit.  
  That is all handled automatically.  All you have to do is give the global 
  Variable MaxElements a value With the number of elements you want in the 
  Array and then call the Procedure initialise.  From then on your Array is 
  called data^. (Actually it is called nothing as it is dynamic and is 
  referenced via the Pointer "data" but if you think of it as being called 
  "data^" you don't even need to know how Pointers work!)

  The Array, using this Unit, can only be singly dimensioned although there is 
  no reason why the Unit could not be hacked to allow multi-dimensions.
  
 }

Interface

Type
(**)  DataType = LongInt;   { change to whatever Type you want For the Array }
  bigArray = Array[0..0] of DataType;
  bigptr   = ^bigArray;
Var
  data : bigptr;
  MaxElements : LongInt;    { this Variable must have the number of elements }

{----------------------------------------------------------------------------}
Function Element(l:LongInt):Byte;
  
  { Call by passing the element number you wish to reference.                }
  { Always returns zero.  It works by changing the value of the Pointer      }
  { data.  This means that you cannot ever reference your big Array by       }
  {   data^[100000] := whatever;                                             }
  { It MUST always be referenced by calling this Function eg.                }
  {   data^[Element(100000)] := whatever;                                    }
 

{----------------------------------------------------------------------------}
Function AllocateMem(Var b,l): Boolean;
  
  { Returns True if memory was allocated successfully For the big Array and  }
  { False if there was insufficient memory.                                  }

{----------------------------------------------------------------------------}
Procedure Initialise;  { Must be called beFore using any other Procedure     }

{============================================================================}

Implementation

{============================================================================}
{ private declarations }

Const
  max          = 65520 div sizeof(dataType);{ The number of elements/segment }
  initialised  : Boolean = False;
  
Type
  address  =  Record                     { allows arithmetic on the Pointers }
                offset,
                segment : Word;
              end;
  baseArray = Array[0..9] of address;    { For the addresses of the segments }

Var
  base : baseArray;
  

{----------------------------------------------------------------------------}
Function Element(l:LongInt):Byte;

  Var
    theaddress : address Absolute data;
    bigaddress : baseArray Absolute base;

  begin
    
    { First make sure that initialisation has been done correctly            }
    if not initialised then begin 
      Writeln('Initialise Procedure has not been called');
      halt(254);
    end;  { if not initialised }
    
    Element := 0; { It is Really irrelevent but any other value here would   }
                  { produce a range check error at runtime if R+             }
    
    { Now let us fool TP into thinking that the address of element zero is   }
    { address of the element we are looking For.                             }
    With theaddress do begin
      segment := bigaddress[l div max].segment;            { Get the segment }
      offset  := (l mod max) * sizeof(dataType);            { Get the offset }
    end;  { With theaddress }
  end;  { ElementNumber }

{----------------------------------------------------------------------------}
Function AllocateMem(Var b,l): Boolean;
  
  Type
    ptrArray = Array[0..9] of Pointer;
  Var
    bArray: ptrArray Absolute b;
    x     : Byte;
    count : LongInt;
  begin
    count := MaxElements;
    AllocateMem := True;
    For x := 0 to (count div max) do     { allocate in 64K contiguous chunks }
      if (count * sizeof(dataType)) > 65520 then begin
        if MaxAvail < (max * sizeof(dataType)) then begin { not enough memory} 
          dec(count,max);
          AllocateMem := False;
        end 
        else
          GetMem(bArray[x],max * sizeof(dataType));
      end
      else
        if MaxAvail < (count * sizeof(dataType)) then
           AllocateMem := False
        else
           GetMem(bArray[x],count * sizeof(dataType)); 
  end;  { AllocateMem }
  
{----------------------------------------------------------------------------}
Procedure Initialise;
  begin
    FillChar(base,sizeof(base),0);
    if not AllocateMem(base,MaxElements) then begin
      Writeln('Insufficient memory');
      halt(255);
    end;
    initialised := True;              { All Ok and memory has been allocated }
  end;  { Initialise }
  
end.  { Unit Oversize }
 
