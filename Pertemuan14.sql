DECLARE customer_cursor CURSOR FOR
SELECT name, email_address
FROM customers;

OPEN customer_cursor;

WHILE TRUE
BEGIN
  FETCH customer_cursor INTO @customer_name, @customer_email;

  IF SQLSTATE_VALUE() = '00000' THEN -- Check for end of result set
    EXIT;
  END IF;

  PRINT CONCAT('Customer Name: ', @customer_name);
  PRINT CONCAT('Customer Email: ', @customer_email);
END;

CLOSE customer_cursor;

CREATE TABLE Penjualan(
	id_jual INT(8) NOT NULL AUTO_INCREMENT,
    kode_pelanggan VARCHAR(10) NOT NULL,
    kode_brg VARCHAR(5),
    nama_barang VARCHAR(35),
    jumlah INT(6),
    harga INT(12),
    PRIMARY KEY (id_jual)
);

CREATE TABLE Pembelian(
	id_beli INT(8) NOT NULL AUTO_INCREMENT,
    kode_brg VARCHAR(5),
    nama_barang VARCHAR(35),
    jumlah INT(6),
    harga INT(12),
    PRIMARY KEY (id_beli)
);

CREATE TABLE Barang(
	id_brg INT(8) NOT NULL AUTO_INCREMENT,
    nama_barang VARCHAR(35),
    jumlah INT(6),
    PRIMARY KEY (id_brg)
);

CREATE TRIGGER stok_barang
BEFORE INSERT
ON Barang FOR EACH ROW
BEGIN
	IF NOT EXIST (SELECT id_brg FROM Barang WHERE id_brg = 
		NEW.id_brg)
	THEN
		SET NEW.nama_barang = NEW.nama_barang, NEW.jumlah =   
		NEW.jumlah;
	ELSE
		SET @status = CONCAT('ID ', NEW.id_brg, 'sudah ada');
	END IF;

CREATE TRIGGER jual_barang
AFTER INSERT
ON Penjualan FOR EACH ROW
BEGIN
	UPDATE barang
		SET jumlah = NEW.jumlah
	WHERE id_brg = NEW.id_brg,
END;

CREATE TRIGGER barang_baru
BEFORE UPDATE
ON BARANG FOR EACH ROW
BEGIN
	UPDATE Barang
	SET nama_barang = 'Gelas'
    WHERE id_brg ='BRG001';SET @status = CONCAT('Data Barang    
		dengan Id ', NEW.id_brg, ' sudah diperbarui');
END;

CREATE TRIGGER barang_baru
BEFORE UPDATE ON BARANG FOR EACH ROW
BEGIN
	UPDATE Barang
    SET jumlah = jumlah + OLD.jumlah
    WHERE id_brg = OLD.jumlah;
END;

CREATE TABLE users( 
	user_id INT AUTO_INCREMENT PRIMARY KEY, 
	username VARCHAR(50) UNIQUE NOT NULL, 
	email VARCHAR(50) NOT NULL
);

DELIMITER //

CREATE PROCEDURE insert_user(
	IN p_username VARCHAR(50), 
	IN p_email VARCHAR(50))
BEGIN
  -- SQLSTATE for unique constraint violation
  DECLARE EXIT HANDLER FOR SQLSTATE '23000'
  BEGIN
    -- Handler actions when a duplicate username is detected
    SELECT 'Error: Duplicate username. Please choose a different username.' AS Message;
  END;
  -- Attempt to insert the user into the table
  INSERT INTO users (username, email) VALUES (p_username, p_email);
  -- If the insertion was successful, display a success message
  SELECT 'User inserted successfully' AS Message;
END //

DELIMITER ;

SELECT 'Error: Duplicate username. Please choose a different username.' AS Message;

SELECT 'User inserted successfully' AS Message;

CALL insert_user('jane','jane@example.com');