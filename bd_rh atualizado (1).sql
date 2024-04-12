-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Tempo de geração: 12/04/2024 às 08:50
-- Versão do servidor: 10.4.32-MariaDB
-- Versão do PHP: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Banco de dados: `bd_rh`
--

-- --------------------------------------------------------

--
-- Estrutura para tabela `departamentos`
--

CREATE TABLE `departamentos` (
  `id_dep` int(11) NOT NULL,
  `nome_dep` varchar(50) NOT NULL,
  `total_func` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Despejando dados para a tabela `departamentos`
--

INSERT INTO `departamentos` (`id_dep`, `nome_dep`, `total_func`) VALUES
(1, 'comercial', 3),
(2, 'RH', 2),
(3, 'setor criação e design', 2);

-- --------------------------------------------------------

--
-- Estrutura para tabela `folha_pagamento`
--

CREATE TABLE `folha_pagamento` (
  `id` int(11) NOT NULL,
  `fk_id_func` int(11) DEFAULT NULL,
  `valor_liquido` decimal(10,2) NOT NULL CHECK (`valor_liquido` > 0),
  `descontos` decimal(10,2) NOT NULL CHECK (`descontos` > 0),
  `total_salario` decimal(10,2) NOT NULL CHECK (`total_salario` > 0),
  `data_pagamento` date DEFAULT NULL CHECK (`data_pagamento` >= '2023-12-31')
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Despejando dados para a tabela `folha_pagamento`
--

INSERT INTO `folha_pagamento` (`id`, `fk_id_func`, `valor_liquido`, `descontos`, `total_salario`, `data_pagamento`) VALUES
(1, 4, 5732.45, 756.89, 4975.56, '2024-01-10'),
(2, 7, 4752.14, 300.46, 4451.68, '2024-01-10'),
(10, 1, 3546.54, 456.12, 3090.42, '2024-01-10'),
(11, 5, 1046.07, 512.19, 533.88, '2024-01-10'),
(12, 6, 8423.41, 724.46, 7698.95, '2024-01-10'),
(13, 8, 3546.45, 358.74, 3187.71, '2024-01-10'),
(14, 9, 20785.32, 2000.54, 18784.78, '2024-01-10');

--
-- Acionadores `folha_pagamento`
--
DELIMITER $$
CREATE TRIGGER `tr_total_salario` BEFORE INSERT ON `folha_pagamento` FOR EACH ROW BEGIN
    SET NEW.total_salario = NEW.valor_liquido - NEW.descontos;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estrutura para tabela `funcionarios`
--

CREATE TABLE `funcionarios` (
  `id_func` int(11) NOT NULL,
  `nome_func` varchar(50) NOT NULL,
  `idade_func` int(11) NOT NULL,
  `fk_id_dep` int(11) DEFAULT NULL,
  `sexo` char(1) NOT NULL CHECK (`sexo` in ('m ','f')),
  `cpf` char(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Despejando dados para a tabela `funcionarios`
--

INSERT INTO `funcionarios` (`id_func`, `nome_func`, `idade_func`, `fk_id_dep`, `sexo`, `cpf`) VALUES
(1, 'Paulo Santos', 26, 3, 'm', '2147483647'),
(4, 'Robert Oliveira', 30, 2, 'm', '46795238107'),
(5, 'Adriano gabirú', 42, 1, 'm', '12345678911'),
(6, 'Henry Goulart', 62, 1, 'm', '45736912464'),
(7, 'Fabio da Silva', 22, 2, 'm', '43679251873'),
(8, 'Adriana Schwaizki', 50, 1, 'f', '46731982576'),
(9, 'Eduarda Monteiro', 24, 3, 'f', '13796287677');

--
-- Acionadores `funcionarios`
--
DELIMITER $$
CREATE TRIGGER `tr_total_func` AFTER INSERT ON `funcionarios` FOR EACH ROW BEGIN
	UPDATE departamentos 
    SET total_func = total_func + 1
    WHERE id_dep = NEW.fk_id_dep;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estrutura stand-in para view `sal_maior_media`
-- (Veja abaixo para a visão atual)
--
CREATE TABLE `sal_maior_media` (
`id` int(11)
,`fk_id_func` int(11)
,`valor_liquido` decimal(10,2)
,`descontos` decimal(10,2)
,`total_salario` decimal(10,2)
,`data_pagamento` date
);

-- --------------------------------------------------------

--
-- Estrutura stand-in para view `soma_salarios`
-- (Veja abaixo para a visão atual)
--
CREATE TABLE `soma_salarios` (
`nome_func` varchar(50)
,`cpf` char(11)
,`soma_dos_salarios` decimal(32,2)
);

-- --------------------------------------------------------

--
-- Estrutura para tabela `vales`
--

CREATE TABLE `vales` (
  `fk_id_func` int(11) DEFAULT NULL,
  `valor_vt` decimal(10,2) NOT NULL CHECK (`valor_vt` > 0),
  `valor_va` decimal(10,2) NOT NULL CHECK (`valor_va` > 0),
  `plano_saude` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Despejando dados para a tabela `vales`
--

INSERT INTO `vales` (`fk_id_func`, `valor_vt`, `valor_va`, `plano_saude`) VALUES
(1, 200.00, 550.00, 'Unimax'),
(4, 100.00, 550.00, 'Unimax'),
(5, 320.00, 550.00, 'Unimax'),
(6, 300.00, 550.00, 'Unipart'),
(7, 100.00, 550.00, 'Unipart'),
(8, 250.00, 550.00, 'Unifacil'),
(9, 10.00, 550.00, 'Unifacil');

-- --------------------------------------------------------

--
-- Estrutura para view `sal_maior_media`
--
DROP TABLE IF EXISTS `sal_maior_media`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `sal_maior_media`  AS SELECT `folha_pagamento`.`id` AS `id`, `folha_pagamento`.`fk_id_func` AS `fk_id_func`, `folha_pagamento`.`valor_liquido` AS `valor_liquido`, `folha_pagamento`.`descontos` AS `descontos`, `folha_pagamento`.`total_salario` AS `total_salario`, `folha_pagamento`.`data_pagamento` AS `data_pagamento` FROM `folha_pagamento` WHERE `folha_pagamento`.`total_salario` > (select avg(`folha_pagamento`.`total_salario`) AS `maiores_salarios` from `folha_pagamento`) ;

-- --------------------------------------------------------

--
-- Estrutura para view `soma_salarios`
--
DROP TABLE IF EXISTS `soma_salarios`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `soma_salarios`  AS SELECT `fun`.`nome_func` AS `nome_func`, `fun`.`cpf` AS `cpf`, (select sum(`fol`.`total_salario`) from `folha_pagamento` `fol` where `fun`.`id_func` = `fol`.`fk_id_func`) AS `soma_dos_salarios` FROM `funcionarios` AS `fun` ;

--
-- Índices para tabelas despejadas
--

--
-- Índices de tabela `departamentos`
--
ALTER TABLE `departamentos`
  ADD PRIMARY KEY (`id_dep`);

--
-- Índices de tabela `folha_pagamento`
--
ALTER TABLE `folha_pagamento`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_folha_func` (`fk_id_func`);

--
-- Índices de tabela `funcionarios`
--
ALTER TABLE `funcionarios`
  ADD PRIMARY KEY (`id_func`),
  ADD UNIQUE KEY `unique_cpf` (`cpf`),
  ADD KEY `fk_dep_fun` (`fk_id_dep`);

--
-- Índices de tabela `vales`
--
ALTER TABLE `vales`
  ADD KEY `fk_func_vales` (`fk_id_func`);

--
-- AUTO_INCREMENT para tabelas despejadas
--

--
-- AUTO_INCREMENT de tabela `departamentos`
--
ALTER TABLE `departamentos`
  MODIFY `id_dep` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT de tabela `folha_pagamento`
--
ALTER TABLE `folha_pagamento`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=15;

--
-- AUTO_INCREMENT de tabela `funcionarios`
--
ALTER TABLE `funcionarios`
  MODIFY `id_func` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- Restrições para tabelas despejadas
--

--
-- Restrições para tabelas `folha_pagamento`
--
ALTER TABLE `folha_pagamento`
  ADD CONSTRAINT `fk_folha_func` FOREIGN KEY (`fk_id_func`) REFERENCES `funcionarios` (`id_func`);

--
-- Restrições para tabelas `funcionarios`
--
ALTER TABLE `funcionarios`
  ADD CONSTRAINT `fk_dep_fun` FOREIGN KEY (`fk_id_dep`) REFERENCES `departamentos` (`id_dep`);

--
-- Restrições para tabelas `vales`
--
ALTER TABLE `vales`
  ADD CONSTRAINT `fk_func_vales` FOREIGN KEY (`fk_id_func`) REFERENCES `funcionarios` (`id_func`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
