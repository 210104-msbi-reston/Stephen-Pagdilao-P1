# PROJECT NAME

## Project Description

Created a database structure using MS SQL Server with SQL Server Agent to collaborate with MSBI to extract data from different sources and transforming the data into a singular format and load it to a centralized database

## Technologies Used

* MS SQL Server - version 2016
* SQL Server Integration Service - Visual Studio 2019

## Features

List of features
* Automatically loading data from multiple sources using SSIS
* Database will fill out tables with information based on country's properties such as its population
* Normalized database to reduce redundancy
* Multiple views created for statistical analysis
* Created numerous clustered, non-clustered, and column store indexes to retrieve data quickly

To-do list:
* Add SQL Server Analysis Server to do further analysis
* Add SQL Server Reporting Server to represent data in a meaningful way

## Getting Started
Requirements
* Visual Studio 2019
* MS SQL Server 2016
* SQL Server Integration Server

Steps to pulling repo to a directory
1. Create a directory that will store the project data
2. Locate that directory in Git Bash
3. Type git init and press Enter
4. Type git pull https://github.com/210104-msbi-reston/Stephen-Pagdilao-P1.git and it will transfer everything to the folder you have specified (Below image is what the folder should look like after pulling)
<img src="Images/Project%20file%20image.png" width="500">

Adding Database to MS SQL Server
1. Extract DatabaseManagement.rar in the same folder
2. Open MS SQL Server 2016
3. Right click on the Database folder
4. Click on Restore Database...
5. Click on Device under Source
6. Click the Box '...'
7. Click on Add and locate the backup file you have extracted
8. Click on OK and click the OK button again and MS SQL Server should back up your data (Below image is what your SQL Server should look like after restoring the .bak file)
<img src ="Images/SQL%20Server%20Image.png" width="500" >

Adding Visual Studio Project
1. Open Visual Studio 2019
2. Click Open a project or solution
3. Locate the directory you pulled the git from
4. Open the VS Code folder
5. Open DatabaseManagement folder
6. Open the DatabaseManagement Visual Studio Solution (Below image is what your Visual Studio should look like after opening the project solution file)
<img src ="Images/Visual%20Studio%20Image.png" width="500" >

## Usage

You can use any sql queries you want to explore the database that is already created. There are a couple of views already made in the database to look at the statistics or overview of the database. 

## License

This project uses the following license: [Microsoft SQL Server 2016 License](https://www.microsoft.com/en-us/sql-server/sql-server-2016), [Visual Studio 2019 License](https://visualstudio.microsoft.com/vs/).

