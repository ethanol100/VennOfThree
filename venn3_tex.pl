#!/usr/bin/perl
use strict;
use warnings;
use Math::Trig;
use constant PI    => 4 * atan2(1, 1);
my $arguments=$#ARGV+1;
if($arguments!=6){print "Usage: ./venn3_tex.pl a1 a2 a3 dA12 dA13 dA23\n";}
else{
my $A10=$ARGV[0];
my $A20=$ARGV[1];
my $A30=$ARGV[2];
my $U12=$ARGV[3];
my $U13=$ARGV[4];
my $U23=$ARGV[5];

my $r12=0;
my $r13=0;
my $r23=0;

if($U12!=0){ $r12=calcABS($A10,$A20,$U12);}
if($U13!=0){ $r13=calcABS($A10,$A30,$U13);} 
if($U23!=0){ $r23=calcABS($A20,$A30,$U23);}
print "%$r12 $r13 $r23\n";
my $r10=sqrt($A10/PI);
my $r20=sqrt($A20/PI);
my $r30=sqrt($A30/PI);
print "%$r10 $r20 $r30\n";

if($U12!=0 && $U13!=0 && $U23!=0){
my $x1=0;
my $y1=0;
my $x2=$r12;
my $y2=0;
my $x3=($r13*$r13-$r23*$r23)/(2*$r12)+$r12/2;
my $y3=0;
if($r13*$r13-$x3*$x3>=0){
$y3=sqrt($r13*$r13-$x3*$x3);
}
texout($r10,$r20,$r30,$x1,$y1,$x2,$y2,$x3,$y3);
}
else{
 if($U12!=0 && $U13!=0 && $U23==0){
my $x1=0;
my $y1=0;
my $x2=$r12;
my $y2=0;
my $x3=0;
my $y3=-$r13;
texout($r10,$r20,$r30,$x1,$y1,$x2,$y2,$x3,$y3);
 }
 else{
  if($U12!=0 && $U13==0 && $U23!=0){
   my $x1=0;
   my $y1=0;
   my $x2=$r12;
   my $y2=0;
   my $x3=0;
   my $y3=$r12+$r13;
   texout($r10,$r20,$r30,$x1,$y1,$x2,$y2,$x3,$y3);
  }
  else{
   if($U12==0 && $U13!=0 && $U23!=0){
    my $x1=0;
    my $y1=0;
    my $x2=$r23+$r13;
    my $y2=0;
    my $x3=0;
    my $y3=$r13;
    texout($r10,$r20,$r30,$x1,$y1,$x2,$y2,$x3,$y3);
   }
   else{
   print "Hm irgend wie haengen die nicht zusammen.. \n";
   }
  }
 }
}
 
}

sub calcABS{
my $A1  = shift;
my $A2 = shift;
my $U = shift;

my $r1=sqrt($A1/PI);
my $r2=sqrt($A2/PI);
my $amin;
my $amax;
my $amean;
my $fehler;
my $ueberlapp;
if($r1>=$r2){ 
 $amin=($r1-$r2);
 $amax=($r1+$r2);
 $ueberlapp=$U/$A1;
}
else {
 $amin=($r2-$r1); 
 $amax=($r1+$r2);
 $ueberlapp=$U/$A2;
}

my $ag=$amax*$ueberlapp+$amin*(1-$ueberlapp);

my $A=calcA($r1,$r2,$ag);
my $G=$r1/1000;
my $itermax=100;
my $dA=$U-$A;
my $iter=0;

if($dA>=0){
 #(A zu klein)
 $amax=$ag;
 while($amax-$amin>$G && $iter<$itermax){
 $iter++;
 my $versuch=($amax+$amin)/2.;
 $A=calcA($r1,$r2,$versuch);
 $dA=$U-$A;
 if($dA>=0){$amax=$versuch;}
 else{$amin=$versuch;} 
 }
 $amean=($amax+$amin)/2.;
 $fehler=$amax-$amean;
}
else{
 #(A zu gross)
 $amin=$ag;
 while($amax-$amin>$G && $iter<$itermax){
 $iter++;
 my $versuch=($amax+$amin)/2.;
 $A=calcA($r1,$r2,$versuch);
 $dA=$U-$A;
 if($dA<=0){$amin=$versuch;}
 else{$amax=$versuch;} 
 }
 $amean=($amax+$amin)/2.; 
 $fehler=$amax-$amean;
}
return $amean;
}


sub calcA {
 my $ra = shift;
 my $rb = shift;
 my $abs = shift;
 my $AA=(acos(($ra*$ra-$rb*$rb)/(2*$abs*$ra)+$abs/2/$ra)*$ra*$ra+acos(($rb*$rb-$ra*$ra)/(2*$abs*$rb)+$abs/2/$rb)*$rb*$rb)-$abs*sqrt($ra*$ra-(($ra*$ra-$rb*$rb)/2/$abs+$abs/2)*(($ra*$ra-$rb*$rb)/2/$abs+$abs/2));
  return $AA;
}

sub texout{
 my $ra = shift;
 my $rb = shift;
 my $rc = shift;
 my $xa = shift;
 my $ya = shift;
 my $xb = shift;
 my $yb = shift;
 my $xc = shift;
 my $yc = shift;

 my $txa=($xa-($xa+$xb+$xc)/3)/10;
 my $txb=($xb-($xa+$xb+$xc)/3)/10;
 my $txc=($xc-($xa+$xb+$xc)/3)/10;
 my $tya=-($ya-($ya+$yb+$yc)/3)/10;
 my $tyb=-($yb-($ya+$yb+$yc)/3)/10;
 my $tyc=-($yc-($ya+$yb+$yc)/3)/10;
 $ra=$ra/10;
 $rb=$rb/10;
 $rc=$rc/10;
 
 print "\\def\\firstcircle{($txa,$tya) circle ($ra cm)}\n";
 print "\\def\\secondcircle{($txb,$tyb) circle ($rb cm)}\n";
 print "\\def\\thirdcircle{($txc,$tyc) circle ($rc cm)}\n";
}