Program Bataille_navale ;

uses crt ;

Const 
Nbbateau = 5 ;
Maxcells = 5  ;
MinL	= 1 ;
MaxL = 50 ;
MinC   = 1 ;
MaxC	= 50 ;

// Types

Type Cells = record
	Ligne : integer;
	Col : integer;
END ;
Type bateau = record 
	ncells : array [1..Maxcells] of cells ;
	taille : integer ;
END;
Type flotte = record 
	NBateau : array [ 1..Nbbateau] of bateau
END;

Type position_bateau = ( en_ligne, en_colonne, en_diagonale) ;
Type etat_bateau = (touche, couler ) ;
Type etat_flotte = (a_flot , a_sombrer) ;
Type etat_joueur = (gagner , perd) ;
 


//Procedures & fonctions

Procedure createcells (l, c : integer ; VAR mcells : cells ) ;
begin;
	mcells.ligne := l;
	mcells.col := c;
end ;

Function createcells (l,c : integer  ) :cells ;
	VAR
	mcells : cells ;
		begin
			mcells.ligne :=l;
			mcells.col := c;
			Createcells := mcells;
		end ;
Function cmpcells (ncells, tcells : cells ) : boolean ;
begin 
	if ((ncells .col = tcells.col ) and (ncells .ligne = tcells.ligne)) then 
		cmpcells := true
	else
		cmpcells := false
end ;

FUNCTION createBateau(nCellule:cells; taille:integer):bateau;  //function crea bateux
var
	res:bateau;	
	posBateau:position_Bateau;	
	i:integer;	
	pos:integer;	

begin
	
	pos:=Random(3);
	posBateau := position_Bateau(pos);
	Res.taille := taille;
	
	for i:=1 to Maxcells do
	begin
		
		if (i<=taille) then
		begin
			res.ncells[i].ligne:=nCellule.ligne;
			res.ncells[i].col:=nCellule.col;
		end
		else
		begin
			res.ncells[i].ligne:=0;
			res.ncells[i].col:=0;
		end;
		
		
		if (posBateau=en_Ligne) then
			nCellule.col:=nCellule.col+1
		else
			//en colonne
			if (posBateau=en_Colonne) then
				nCellule.ligne:=nCellule.ligne+1
			else
				//en diagonale
				if (posBateau=en_diagonale) then
				begin
					nCellule.ligne:=nCellule.ligne+1;
					nCellule.col:=nCellule.col+1;
				end;
	end;

	createBateau:=res;
end;

Function ctrlcells (nbat : bateau ; ncells : cells ) : boolean ;
VAR
Valtest : boolean ;
i: integer ;

begin 
Valtest := false ; 
for i := 1 to Maxcells do 
begin 
if ( cmpcells(nbat.ncells[i],ncells )) then
Valtest := true ;
end ;
Ctrlcells := valtest ;
end ;

Function ctrlflotte (nflotte : flotte ; ncells : cells ; player : flotte) :  boolean;
Var 
i : integer ;
Valtest : boolean ;
begin 
Valtest  := false ;
for i := 1 to Nbbateau do
if (ctrlcells (nflotte.nbateau[i], ncells)) then 
Valtest  := true ;

Ctrlflotte := valtest ; 
end ;



procedure flottePlayer (var nBateau:bateau;var nCellule:cells);
begin
	
	repeat
		nBateau.taille:=Random(Maxcells)+3;
	until (nBateau.taille>2) and (nBateau.taille<=Maxcells);
	
	
	
	repeat
		Createcells((Random(MAXL)+MINL),(Random(MAXC)+MINL),nCellule);
	until (nCellule.ligne>=MINL) and (nCellule.ligne<=MAXL-nBateau.taille) and (nCellule.col>=MINC) and (nCellule.col<=MAXC-nBateau.taille);

	nBateau:=createBateau(nCellule,nBateau.taille);
end;

procedure initflottePlayer(var player:flotte; MCellule:cells); 
var
  i,j:integer;	
begin
	for i:=1 to NBBATEAU do
	begin
		flottePlayer(player.nBateau[i],MCellule);
	end;
end;



procedure attaquer(var player:flotte);
var
	MCells:cells;	
	test:boolean;	
	i,j:integer;	
begin
	
	repeat
		writeln('Entrez la ligne [1-12]');
		readln(MCells.ligne);
		if (MCells.ligne<1) or (MCells.ligne>12) then writeln('erreur [1-12]');
	until (MCells.ligne>0) and (MCells.ligne<=12);
	
	repeat
		writeln('Entrez la colonne [1-12]');
		readln(MCells.col);
		if (MCells.col<1) or (MCells.col>12) then writeln('erreur [1-12]');
	until (MCells.col>0) and (MCells.col<=12);
	
	for i:=1 to NBBATEAU do
	begin
		for j:=1 to player.nBateau[i].taille do
		begin
			test:=false;
			
			test:=cmpcells(MCells,player.nBateau[i].ncells[j]);
		
			if test then
			begin
				writeln('touche ! ');
				CreateCells(0,0,player.nBateau[i].ncells[j]);
			end;
		end;
	
	end;
end;



var
	MCellule:cells;	
	i:integer;
	joueur1,joueur2:flotte;	
	etat1,etat2:etat_Joueur;	
	etatf1,etatf2:etat_Flotte;	

	
begin
	clrscr;
	randomize;
	etat1:=gagner;
	etat2:=gagner;
	etatf1:=a_Flot;
	etatf2:=a_Flot;
	
	writeln('Initialisation des donnees du joueur 1.');
	initflottePlayer(joueur1,MCellule);
	writeln('Initialisation des donnees du joueur 2.');
	initflottePlayer(joueur2,MCellule);
	

	repeat
		
		
		if (etat1=gagner) and (etat2=gagner) then
		begin
			writeln('Joueur 1 : ');
			attaquer(joueur1);
		end;		
		
		
		if etatf1=a_Sombrer then
			etat2:=perd; 
		
		
		if (etat1=gagner) and (etat2=gagner) then
		begin
			writeln('Joueur 2 : ');
			attaquer(joueur2);
		end;
		
		
		if etatf2=a_Sombrer then
			etat1:=perd;
		
	until ((etat1=perd) or (etat2=perd)) and ((etatf1=a_Sombrer) or (etatf2=a_Sombrer));
	
	if etat1=perd then writeln('Joueur 2 a gagner')
	else writeln('Joueur 1 a gagner');
	
	readln;
end.





