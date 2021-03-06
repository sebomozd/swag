{

   Pointers functions: returns the segment and the offset in hexadecimal
   value (in a string variable)


               浜様様様様様様様様様様様様様様様様様様様融
               �                                        紺
               �          AVONTURE CHRISTOPHE           紺
               �              AVC SOFTWARE              紺
               �     BOULEVARD EDMOND MACHTENS 157/53   紺
               �           B-1080 BRUXELLES             紺
               �              BELGIQUE                  紺
               �                                        紺
               藩様様様様様様様様様様様様様様様様様様様夕�
               旭旭旭旭旭旭旭旭旭旭旭旭旭旭旭旭旭旭旭旭旭�

}

Function Segment (Chiffre : Pointer)  : String;

Type TWordRec = Record
       Lo, Hi : Word;
    End;

Begin

     Segment := Word2Hex(TWordRec(Chiffre).Hi);

End;

Function Offset (Chiffre : Pointer)  : String;

Type TWordRec = Record
       Lo, Hi : Word;
    End;

Begin

     Offset := Word2Hex(TWordRec(Chiffre).Lo);

End;

Var
   p : Pointer;

Begin

   p := Ptr($B800:$0000);

   Writeln (Segment(p),":",Offset(p));

End.