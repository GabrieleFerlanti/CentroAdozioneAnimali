#Registrare un animale con una persona già registrato 
CALL RegistraAnimale ('RSSMRA97M15A001G', '1A2B3C4D5E6F7G8', 'Luna', 1, 'cane', 'medio', 'grande', 'Golden Retriever', '2024-03-01'); #Chiamata [CALL] alla procedura RegistraAnimale ('ValoriDaPassare',)

#Registrare un animale con una persona non registrata
#CALL RegistraAnimale ('BRSRPA88R25E005W', 'QW3E4R5T6Y7U8I9', 'Max', 3, 'cane', 'medio', 'grande', 'Pastore Tedesco', '2024-03-01');
CALL RegistraPersona ('BRSRPA88R25E005W', 'Giovanni', 'Ferrari', 'Via Dante Alighieri 30', '7775551234', 'giovanni.ferrari@example.com');
CALL RegistraAnimale ('BRSRPA88R25E005W', 'QW3E4R5T6Y7U8I9', 'Max', 3, 'cane', 'medio', 'grande', 'Pastore Tedesco', '2024-03-01');

CALL Donazione ('BRSRPA88R25E005W', '20.00', '2024-01-04');
CALL Donazione ('LNNPLA91M45B002Y', '900.00', '2024-02-01');
CALL Donazione ('BRSRPA88R25E005W', '700.00', '2024-02-04');


CALL AdottanoAnimale ('GRTPLM84C30C003Z', 'QW3E4R5T6Y7U8I9', '2024-04-01');
CALL AdottanoAnimale ('LNNPLA91M45B002Y', '1A2B3C4D5E6F7G8', '2024-03-03');

SELECT DonazioniRicevute ('2024-02-01'); #[SELECT] per invocare una funzione ('ValoriDaPassare',)

SELECT AnimaliAdottati ('2024-02-01');

SELECT AnimaliRegistrati('2024-02-01');