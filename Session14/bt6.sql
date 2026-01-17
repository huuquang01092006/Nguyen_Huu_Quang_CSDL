-- bai 6
use social_network;

create table friend_requests (
	request_id int auto_increment primary key,
	from_user_id int,
	to_user_id int,
	status enum('pending','accepted','rejected') default 'pending'
);

create table friends (
	user_id int,
	friend_id int,
	primary key (user_id, friend_id)
);

alter table users
add column friends_count int default 0;

delimiter $$

create procedure accept_friend_request(
	in p_request_id int,
	in p_to_user_id int
)
begin
	declare exit handler for sqlexception
	begin
		rollback;
	end;

	set transaction isolation level repeatable read;
	start transaction;

	if not exists (
		select request_id from friend_requests
		where request_id = p_request_id
		and to_user_id = p_to_user_id
		and status = 'pending'
	) then
		rollback;
		signal sqlstate '45000';
	end if;

	insert into friends (user_id, friend_id)
	select from_user_id, to_user_id
	from friend_requests 
	where request_id = p_request_id;

	insert into friends (user_id, friend_id)
	select to_user_id, from_user_id
	from friend_requests
	where request_id = p_request_id;

	update users
	set friends_count = friends_count + 1
	where user_id in (
		select from_user_id from friend_requests where request_id = p_request_id
		union
		select to_user_id from friend_requests where request_id = p_request_id
	);

	update friend_requests
	set status = 'accepted'
	where request_id = p_request_id;

	commit;
end $$

delimiter ;

insert into friend_requests (from_user_id, to_user_id)
values (1, 2);

call accept_friend_request(1, 2);
call accept_friend_request(1, 2);
