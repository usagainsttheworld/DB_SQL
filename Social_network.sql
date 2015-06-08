/* Delete the tables if they already exist */
drop table if exists Highschooler;
drop table if exists Friend;
drop table if exists Likes;

/* Create the schema for our tables */
create table Highschooler(ID int, name text, grade int);
create table Friend(ID1 int, ID2 int);
create table Likes(ID1 int, ID2 int);

/* Populate the tables with our data */
insert into Highschooler values (1510, 'Jordan', 9);
insert into Highschooler values (1689, 'Gabriel', 9);
insert into Highschooler values (1381, 'Tiffany', 9);
insert into Highschooler values (1709, 'Cassandra', 9);
insert into Highschooler values (1101, 'Haley', 10);
insert into Highschooler values (1782, 'Andrew', 10);
insert into Highschooler values (1468, 'Kris', 10);
insert into Highschooler values (1641, 'Brittany', 10);
insert into Highschooler values (1247, 'Alexis', 11);
insert into Highschooler values (1316, 'Austin', 11);
insert into Highschooler values (1911, 'Gabriel', 11);
insert into Highschooler values (1501, 'Jessica', 11);
insert into Highschooler values (1304, 'Jordan', 12);
insert into Highschooler values (1025, 'John', 12);
insert into Highschooler values (1934, 'Kyle', 12);
insert into Highschooler values (1661, 'Logan', 12);

insert into Friend values (1510, 1381);
insert into Friend values (1510, 1689);
insert into Friend values (1689, 1709);
insert into Friend values (1381, 1247);
insert into Friend values (1709, 1247);
insert into Friend values (1689, 1782);
insert into Friend values (1782, 1468);
insert into Friend values (1782, 1316);
insert into Friend values (1782, 1304);
insert into Friend values (1468, 1101);
insert into Friend values (1468, 1641);
insert into Friend values (1101, 1641);
insert into Friend values (1247, 1911);
insert into Friend values (1247, 1501);
insert into Friend values (1911, 1501);
insert into Friend values (1501, 1934);
insert into Friend values (1316, 1934);
insert into Friend values (1934, 1304);
insert into Friend values (1304, 1661);
insert into Friend values (1661, 1025);
insert into Friend select ID2, ID1 from Friend;

insert into Likes values(1689, 1709);
insert into Likes values(1709, 1689);
insert into Likes values(1782, 1709);
insert into Likes values(1911, 1247);
insert into Likes values(1247, 1468);
insert into Likes values(1641, 1468);
insert into Likes values(1316, 1304);
insert into Likes values(1501, 1934);
insert into Likes values(1934, 1501);
insert into Likes values(1025, 1101);

/****************************************************************/
/* Q1 Find the names of all students who are friends with someone named Gabriel.*/
select name 
from Highschooler
where ID in (select	ID2
			from	Highschooler, Friend
			where	highschooler.ID=Friend.ID1
					and name='Gabriel'
			)

/* Q2 For every student who likes someone 2 or more grades younger than themselves, return that student's name and grade, and the name and grade of the student they like. */
select	h1.name, h1.grade, h2.name, h2.grade
from	Highschooler h1, Highschooler h2, Likes
where 	h1.ID=Likes.ID1 and h2.ID=Likes.ID2 
				and h1.grade - h2.grade >= 2

/* Q3 For every pair of students who both like each other, return the name and grade of both students. Include each pair only once, with the two names in alphabetical order. */
select	h1.name, h1.grade, h2.name, h2.grade
from	Likes L1, Likes L2, Highschooler h1, Highschooler h2
where	h1.ID=L1.ID1  and h2.ID = L1.ID2 
		and L1.ID1 = L2.ID2 
		and L1.ID2 = L2.ID1
		and h1.name < h2.name

/* Q4 Find all students who do not appear in the Likes table (as a student who likes or is liked) and return their names and grades. Sort by grade, then by name within each grade. */
select	name, grade
from	Highschooler
where	ID not in (select ID1 from Likes) and ID not in (select ID2 from Likes)
order by	grade, name

/*Q5 For every situation where student A likes student B, but we have no information about whom B likes (that is, B does not appear as an ID1 in the Likes table), return A and B's names and grades.*/
select	h1.name, h1.grade, h2. name, h2.grade
from 	Highschooler h1, Highschooler h2, Likes
where	h1.ID=Likes.ID1 and h2.ID=Likes.ID2 and h2.ID not in (select ID1 from Likes)

/* Q6 Find names and grades of students who only have friends in the same grade. Return the result sorted by grade, then by name within each grade. */
select	name, grade
from	Highschooler
where	ID not in 	(select	h1.ID
					from	Highschooler h1, HIghschooler h2, Friend
					where	h1.ID=Friend.ID1 
							and h2.ID=Friend.ID2
							and h1.grade<>h2.grade
					)
order by	grade, name

/* Q7 For each student A who likes a student B where the two are not friends, find if they have a friend C in common (who can introduce them!). For all such trios, return the name and grade of A, B, and C. */
select	distinct h1.name, h1.grade, h2.name, h2.grade, h3.name, h3.grade
from	Highschooler h1, Highschooler h2, Highschooler h3, Likes, Friend f1, Friend f2
where	h1.ID=Likes.ID1 and h2.ID=Likes.ID2
		and h2.ID not in (select Friend.ID2 from friend where ID1 = h1.ID)
		and h1.ID =f1.ID1 and h3.ID =f1.ID2
		and h2.ID=f2.ID1 and h3.ID=f2.ID2
				
/* Q8 Find the difference between the number of students in the school and the number of different first names. */
select	id.idnum - name.namenum
from	(select count(ID) as idnum from Highschooler) as id,
		(select count(distinct name) as namenum from Highschooler ) as name

/* Q9 Find the name and grade of all students who are liked by more than one other student. */
select	name, grade
from	Highschooler, Likes
where	ID=Likes.ID2 
group by	ID2
having	count(ID1) >1

/* Q10 For every situation where student A likes student B, but student B likes a different student C, return the names and grades of A, B, and C. */
select	h1.name, h1.grade, h2.name, h2.grade, h3.name, h3.grade
from	Highschooler h1, Highschooler h2, Highschooler h3, Likes L1, Likes L2
where	h1.ID=L1.ID1
		and h2.ID=L1.ID2
		and h1.ID not in (select ID2 from Likes where ID1=h2.ID)
		and h2.ID= L2.ID1
		and h3.ID=L2.ID2
				
/* Q11 Find those students for whom all of their friends are in different grades from themselves. Return the students' names and grades. */
select	distinct h1.name, h1.grade
from	Highschooler h1, Highschooler h2, Friend
where	not exists (select grade 
					from Highschooler h2, Friend
					where h1.ID=Friend.ID1 
					and h2.ID=Friend.ID2
					and h1.grade = h2.grade
					)

/* Q12 What is the average number of friends per student? (Your result should be just one number.) */
select	avg(friendperID) as avefriend
from	(select	ID1, count(ID2) as friendperID
		from	Friend
		group by ID1) as friendperIDtable
					
/* Q13 Find the number of students who are either friends with Cassandra or are friends of friends of Cassandra. Do not count Cassandra, even though technically she is a friend of a friend. */
select	count(ID)
from	(select	ID, name
		from	Highschooler
		where	ID in 	(select f1.ID2
						from Friend f1, Highschooler 
						where	Highschooler.ID=f1.ID1
								and Highschooler.name ='Cassandra'
						) 
		union
		select	ID, name
		from	Highschooler
		where	ID in	(select	f2.ID2
						from	Friend f1, Friend f2, Highschooler 
						where	Highschooler.ID=f1.ID1
								and Highschooler.name ='Cassandra'
								and f1.ID2=f2.ID1
						) 
		except
		select	ID, name
		from	Highschooler
		where	name='Cassandra'
		)			

/* Q14 Find the name and grade of the student(s) with the greatest number of friends. */
select	name, grade
from	Highschooler
where	ID in 	(select	ID1
				from	(select	distinct ID1, count(ID2) as fnum
						from	Friend 
						group by	ID1
						) as fcounts			
				where fnum = 	(select	max(fnum)
								from	(select	distinct ID1, count(ID2) as fnum
										from Friend 
										group by ID1
										) as fcounts
							  	) 
				)
							
/*************************************************/
/*******Modification*********/
/* Q1 It's time for the seniors to graduate. Remove all 12th graders from Highschooler. */
delete	from	Highschooler
where	grade=12

/*Q2 If two students A and B are friends, and A likes B but not vice-versa, remove the Likes tuple. */
delete	from Likes
where	ID1 in (select	h1.ID
				from Likes, Highschooler h1, Highschooler h2, Friend
				where 	h1.ID=Friend.ID1 and h2.ID=friend.ID2
						and h1.ID=Likes.ID1 and h2.ID=Likes.ID2
						and h1.ID not in (select ID2 from Likes where ID1= h2.ID)
				)
		and ID2 in	(select	h2.ID
					from	Likes, Highschooler h1, Highschooler h2, Friend
					where	h1.ID=Friend.ID1 and h2.ID=friend.ID2
							and h1.ID=Likes.ID1 and h2.ID=Likes.ID2
							and h1.ID not in (select ID2 from Likes where ID1= h2.ID)
					)

/* Q3 For all cases where A is friends with B, and B is friends with C, add a new friendship for the pair A and C. Do not add duplicate friendships, friendships that already exist, or friendships with oneself. (This one is a bit challenging; congratulations if you get it right.) */
Insert into	Friend (ID1, ID2)
select		distinct h1.ID, h3.ID
			from	Highschooler h1, Highschooler h2, Highschooler h3, Friend f1, Friend f2
			where	h1.ID=f1.ID1 and h2.ID=f1.ID2
					and h2.ID=f2.ID1 and h3.ID=f2.ID2
					and h1.ID not in (select ID2 from Friend where ID1=h3.ID)
					and h1.ID <> h3.ID