INSERT INTO `addon_account` (name, label, shared) VALUES
	('society_realestate','Agent immobilier',1)
;

INSERT INTO `jobs` (name, label) VALUES
	('realestate','Agent immobilier')
;

INSERT INTO `job_grades` (job_name, grade, name, label, salary, skin_male, skin_female) VALUES
	('realestate',0,'location','Location',10,'{}','{}'),
	('realestate',1,'vendeur','Vendeur',25,'{}','{}'),
	('realestate',2,'gestion','Gestion',40,'{}','{}'),
	('realestate',3,'boss','Patron',0,'{}','{}')
;