use bai01;

create table friendships (
	follower_id int,
	followee_id int,
	status enum('pending','accepted') default 'accepted',
	primary key (follower_id, followee_id),
	foreign key (follower_id) references users(user_id) on delete cascade,
	foreign key (followee_id) references users(user_id) on delete cascade
);

delimiter $$

create trigger after_insert_friendship
after insert on friendships
for each row
begin
	if new.status = 'accepted' then
		update users
		set follower_count = follower_count + 1
		where user_id = new.followee_id;
	end if;
end $$

delimiter ;

delimiter $$

create trigger after_delete_friendship
after delete on friendships
for each row
begin
	if old.status = 'accepted' then
		update users
		set follower_count = follower_count - 1
		where user_id = old.followee_id;
	end if;
end $$

delimiter ;

delimiter $$

create procedure follow_user(
	in p_follower_id int,
	in p_followee_id int,
	in p_status enum('pending','accepted')
)
begin
	if p_follower_id = p_followee_id then
		signal sqlstate '45000'
		set message_text = 'khong duoc tu follow';
	end if;

	if exists (
		select 1 from friendships
		where follower_id = p_follower_id
		and followee_id = p_followee_id
	) then
		signal sqlstate '45000'
		set message_text = 'da ton tai follow';
	end if;

	insert into friendships(follower_id, followee_id, status)
	values (p_follower_id, p_followee_id, p_status);
end $$

delimiter ;

create view user_profile as
select 
	u.user_id,
	u.username,
	u.follower_count,
	u.post_count,
	ifnull(sum(p.like_count),0) as total_likes
from users u
left join posts p on u.user_id = p.user_id
group by u.user_id, u.username, u.follower_count, u.post_count;

call follow_user(2, 1, 'accepted');
call follow_user(3, 1, 'accepted');

select user_id, username, follower_count from users;

delete from friendships where follower_id = 2 and followee_id = 1;

select user_id, username, follower_count from users;

select * from user_profile;
