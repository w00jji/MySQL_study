CREATE TABLE `tradingcomp`.`su_user` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(150) NOT NULL,
  `email` VARCHAR(150) NOT NULL,
  PRIMARY KEY (`id`));
  
  CREATE TABLE `tradingcomp`.`su_user_log` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(150) NOT NULL,
  `email` VARCHAR(150) NOT NULL,
  PRIMARY KEY (`id`));
  
  #trigger_new
create trigger
DELIMITER $$
CREATE TRIGGER `trg_after_update_su_user_new`
AFTER UPDATE
ON `su_user`
FOR EACH ROW
BEGIN
    INSERT INTO `super_user_log`(`name`, `email`) VALUES (NEW.`name`, NEW.`email`);
END $$
DELIMITER ;

update su_user set `email`="asdfgg@gmail.com" where id="2";

#trigger delete
DELIMITER $$
CREATE TRIGGER `trg_delete_su_user`
AFTER DELETE
ON `su_user`
FOR EACH ROW
BEGIN
    INSERT INTO `su_user_log`(`name`, `email`) VALUES (OLD.`name`, OLD.`email`);
END $$
DELIMITER ;

select * from su_user_log;