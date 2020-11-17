--liquibase formatted sql

--changeset Lucas:1
create table "document"(
  id bigserial constraint pkey_document primary key,
  path varchar(255) constraint key_document_path unique,
  type varchar(255),
  created_at timestamp not null default NOW(),
  updated_at timestamp
);

create table "local" (
  id bigserial constraint pkey_local primary key,
  name varchar(255),
  created_at timestamp not null default NOW(),
  updated_at timestamp
);

create table "product" (
  id bigserial constraint pkey_product primary key,
  name varchar(255) constraint key_product_name unique,
  unit_measure varchar(255),
  created_at timestamp not null default NOW(),
  updated_at timestamp
);

create table "product_movement" (
  id bigserial constraint pkey_product_movement primary key,
  type varchar(255),
  created_at timestamp not null default NOW(),
  updated_at timestamp,
  document_id bigint constraint fkey_document references "document"
);

create table "provider" (
  id bigserial constraint pkey_provider primary key,
  name varchar(255) constraint key_provider_name unique,
  created_at timestamp not null default NOW(),
  updated_at timestamp
);

create table "product_provider" (
  id bigserial constraint pkey_product_provider primary key,
  price numeric(19, 2),
  created_at timestamp not null default NOW(),
  updated_at timestamp,
  product_id bigint constraint fkey_product references "product",
  provider_id bigint constraint fkey_provider references provider
);

create table "subsidary" (
  id bigserial constraint pkey_subsidary primary key,
  name varchar(255) constraint key_subsidary_name unique,
  created_at timestamp not null default NOW(),
  update_at timestamp
);

create table "deposit" (
  id bigserial constraint pkey_deposit primary key,
  name varchar(255) constraint key_deposit_name unique,
  is_third_party boolean default false,
  created_at timestamp not null default NOW(),
  updated_at timestamp,
  local_id bigint constraint fkey_local references local,
  subsidary_id bigint constraint fkey_subsidary references "subsidary"
);

create table "product_deposit" (
  id bigserial constraint pkey_product_deposit primary key,
  average_price numeric(19, 2),
  price numeric(19, 2),
  quantity integer,
  created_at timestamp not null default NOW(),
  updated_at timestamp,
  deposit_id bigint constraint fkey_deposit references deposit,
  product_provider_id bigint constraint fkey_product_provider references "product_provider"
);

create table "product_deposit_movement" (
  id bigserial constraint pkey_product_deposit_movement primary key,
  price numeric(19, 2),
  quantity integer,
  created_at timestamp not null default NOW(),
  updated_at timestamp,
  product_deposit_id bigint constraint fkey_product_deposit references "product_deposit",
  product_movement_id bigint constraint fkey_product_movement references "product_movement"
);


create table "cart" (
  id bigserial constraint pkey_cart primary key,
  uuid varchar(255),
  active boolean default true,
  created_at timestamp not null default NOW(),
  updated_at timestamp,
  product_movement_id bigint constraint fkey_product_movement references "product_movement"
);

create table "product_deposit_cart" (
  id bigserial constraint pkey_product_deposit_cart primary key,
  price numeric(19, 2),
  quantity integer,
  created_at timestamp not null default NOW(),
  updated_at timestamp,
  product_deposit_id bigint constraint fkey_product_deposit references "product_deposit",
  cart_id bigint constraint fkey_cart references "cart"
);


create table "product_deposit_promote" (
  id bigserial constraint pkey_product_deposit_promote primary key,
  until timestamp not null,
  created_at timestamp not null default NOW(),
  updated_at timestamp,
  product_deposit_id bigint constraint fkey_product_deposit references "product_deposit"
);

create table "responsible" (
  id bigserial constraint pkey_order primary key,
  name varchar(255) not null
);

create table "order" (
  id bigserial constraint pkey_order primary key,
  type varchar(255) not null,
  status varchar(255) not null,
  closed boolean default false,
  created_at timestamp not null default NOW(),
  updated_at timestamp,
  responsible_id bigint constraint fkey_order references "responsible"
);

create table "order_history" (
  id bigserial constraint pkey_order_history primary key,
  type varchar(255) not null,
  status varchar(255) not null,
  closed boolean default false,
  created_at timestamp not null default NOW(),
  updated_at timestamp,
  order_id bigint constraint fkey_order references "order"
);

create table "quotation" (
  id bigserial constraint pkey_quotation primary key,
  created_at timestamp not null default NOW(),
  updated_at timestamp,
  order_id bigint constraint fkey_order references "order"
);

create table "proposal" (
  id bigserial constraint pkey_proposal primary key,
  choosed boolean default false,
  payment_date timestamp not null,
  delivery_date timestamp not null,
  created_at timestamp not null default NOW(),
  updated_at timestamp,
  quotation_id bigint constraint fkey_quotation references "quotation"
  provider_id bigint constraint fkey_proposal references "provider"
);


create table "proposal_product" (
  id bigserial constraint pkey_proposal_product primary key,
  price numeric(19, 2),
  quantity integer,
  created_at timestamp not null default NOW(),
  updated_at timestamp,
  proposal_id bigint constraint fkey_proposal references "proposal",
  product_id bigint constraint fkey_product references "product"
);

create table "user_info" (
  id bigserial constraint pkey_user_info primary key,
  email varchar(255) not null,
  name varchar(255) not null,
  last_name varchar(255) not null,
  cpf int not null,
  phone_number varchar(255) not null,
  created_at timestamp not null default NOW(),
  updated_at timestamp
);


create table "address" (
  id bigserial constraint pkey_address primary key,
  cep varchar(255) not null,
  number int not null,
  created_at timestamp not null default NOW(),
  updated_at timestamp
);

create table "order_sell" (
  id bigserial constraint pkey_order_sell primary key,
  created_at timestamp not null default NOW(),
  updated_at timestamp,
  order_id bigint constraint fkey_order references "order",
  cart_id bigint constraint fkey_cart references "cart",
  address_id bigint constraint fkey_address references "address",
  user_info_id bigint constraint fkey_user_info references "user_info"
);

create table "bill" (
  id bigserial constraint pkey_bill primary key,
  intern_number int not null,
  our_number int not null,
  due_date timestamp not null,
  original_value numeric(19, 2),
  open_value numeric(19, 2),
  situation varchar(255) not null,
  created_at timestamp not null default NOW(),
  updated_at timestamp,
  document_id bigint constraint fkey_document references "document"
);

create table "bill_to_receive" (
  id bigserial constraint pkey_bill_to_receive primary key,
  drawee boolean default false,
  created_at timestamp not null default NOW(),
  updated_at timestamp,
  bill_id bigint constraint fkey_bill references "bill"
);

create table "bill_to_pay" (
  id bigserial constraint pkey_bill_to_pay primary key,
  created_at timestamp not null default NOW(),
  updated_at timestamp,
  beneficiary_id bigint constraint fkey_provider references "provider",
  bill_id bigint constraint fkey_bill references "bill"
);


create table "movement" (
  id bigserial constraint pkey_movement primary key,
  type  varchar(255) not null,
  original_value numeric(19, 2),
  interest numeric(19, 2),
  penalty numeric(19, 2),
  transaction_code int not null,
  created_at timestamp not null default NOW(),
  updated_at timestamp,
  bill_id bigint constraint fkey_bill references "bill"
);




--changeset Lucas:2
INSERT INTO public.document (id, path, type, created_at, updated_at) VALUES (1, 'PICKUP-RESERVATION', 'PICKUP-RESERVATION', '2020-10-12 19:43:14.967351', null);


INSERT INTO public.local (id, name, created_at, updated_at) VALUES (1, 'Rio de Janeiro', '2020-10-12 19:43:14.967351', null);
INSERT INTO public.local (id, name, created_at, updated_at) VALUES (2, 'Sao Paulo', '2020-10-12 19:47:57.416728', null);
INSERT INTO public.local (id, name, created_at, updated_at) VALUES (4, 'Joinville', '2020-10-12 19:48:38.501941', null);
INSERT INTO public.local (id, name, created_at, updated_at) VALUES (3, 'Curitiba', '2020-10-12 19:48:10.666756', null);

INSERT INTO public.subsidary (id, name, created_at, update_at) VALUES (1, 'GoldenGate', '2020-10-12 19:49:58.017847', null);
INSERT INTO public.subsidary (id, name, created_at, update_at) VALUES (2, 'Intuicao', '2020-10-12 19:50:15.790483', null);
INSERT INTO public.subsidary (id, name, created_at, update_at) VALUES (3, 'Gracinh', '2020-10-12 19:50:23.842215', null);
INSERT INTO public.subsidary (id, name, created_at, update_at) VALUES (4, 'Oliveira', '2020-10-12 19:50:35.659841', null);

INSERT INTO public.deposit (id, name, is_third_party, created_at, updated_at, local_id, subsidary_id) VALUES (1, 'Gela guela', null, '2020-10-12 19:51:39.803092', null, 1, 1);
INSERT INTO public.deposit (id, name, is_third_party, created_at, updated_at, local_id, subsidary_id) VALUES (2, 'Peixe POD', null, '2020-10-12 19:52:18.238653', null, 1, 2);
INSERT INTO public.deposit (id, name, is_third_party, created_at, updated_at, local_id, subsidary_id) VALUES (3, 'Refugio lourera', true, '2020-10-12 19:52:52.791037', null, 2, 3);

INSERT INTO public.provider (id, name, created_at, updated_at) VALUES (1, 'Ouro Minas', '2020-10-12 19:53:35.133576', null);
INSERT INTO public.provider (id, name, created_at, updated_at) VALUES (2, 'Bitmex', '2020-10-12 19:54:06.647009', null);
INSERT INTO public.provider (id, name, created_at, updated_at) VALUES (3, 'Parmetal', '2020-10-12 19:54:17.353459', null);
INSERT INTO public.provider (id, name, created_at, updated_at) VALUES (4, 'New Greenfil', '2020-10-12 19:54:51.953697', null);

INSERT INTO public.product (id, name, unit_measure, created_at, updated_at) VALUES (1, 'Ouro g', 'G', '2020-10-12 19:55:15.438323', null);
INSERT INTO public.product (id, name, unit_measure, created_at, updated_at) VALUES (2, 'Ouro oz', 'OZ', '2020-10-12 16:55:57.000000', null);
INSERT INTO public.product (id, name, unit_measure, created_at, updated_at) VALUES (3, 'Prata g', 'G', '2020-10-12 16:56:16.000000', null);

INSERT INTO public.product_provider (id, price, created_at, updated_at, product_id, provider_id) VALUES (1, 341.00, '2020-10-12 19:56:57.221699', null, 1, 1);
INSERT INTO public.product_provider (id, price, created_at, updated_at, product_id, provider_id) VALUES (2, 341.89, '2020-10-12 19:57:14.090515', null, 1, 2);
INSERT INTO public.product_provider (id, price, created_at, updated_at, product_id, provider_id) VALUES (3, 339.00, '2020-10-12 19:57:37.799134', null, 1, 3);
INSERT INTO public.product_provider (id, price, created_at, updated_at, product_id, provider_id) VALUES (4, 10288.00, '2020-10-12 19:58:54.614244', null, 2, 1);
INSERT INTO public.product_provider (id, price, created_at, updated_at, product_id, provider_id) VALUES (5, 10300.00, '2020-10-12 20:00:39.016791', null, 2, 2);
INSERT INTO public.product_provider (id, price, created_at, updated_at, product_id, provider_id) VALUES (6, 10588.00, '2020-10-12 20:00:39.016791', null, 2, 4);
INSERT INTO public.product_provider (id, price, created_at, updated_at, product_id, provider_id) VALUES (7, 4.76, '2020-10-12 20:00:39.016791', null, 3, 3);
INSERT INTO public.product_provider (id, price, created_at, updated_at, product_id, provider_id) VALUES (9, 5.00, '2020-10-12 20:00:39.016791', null, 3, 4);
INSERT INTO public.product_provider (id, price, created_at, updated_at, product_id, provider_id) VALUES (8, 4.76, '2020-10-12 20:00:39.016791', null, 3, 2);


INSERT INTO public.product_deposit (id, average_price, price, quantity, created_at, updated_at, deposit_id, product_provider_id) VALUES (1, 341.00, 341.00, 100, '2020-10-12 20:04:31.378512', null, 1, 1);
INSERT INTO public.product_deposit (id, average_price, price, quantity, created_at, updated_at, deposit_id, product_provider_id) VALUES (2, 341.89, 341.89, 20, '2020-10-12 20:04:47.894807', null, 1, 2);
INSERT INTO public.product_deposit (id, average_price, price, quantity, created_at, updated_at, deposit_id, product_provider_id) VALUES (3, 10300.00, 10300.00, 3, '2020-10-12 20:06:10.716521', null, 2, 5);
INSERT INTO public.product_deposit (id, average_price, price, quantity, created_at, updated_at, deposit_id, product_provider_id) VALUES (4, 4.76, 4.76, 10000, '2020-10-12 20:06:10.716521', null, 2, 7);
INSERT INTO public.product_deposit (id, average_price, price, quantity, created_at, updated_at, deposit_id, product_provider_id) VALUES (5, 341.00, 341.00, 40, '2020-10-12 20:06:10.716521', null, 3, 1);
INSERT INTO public.product_deposit (id, average_price, price, quantity, created_at, updated_at, deposit_id, product_provider_id) VALUES (13, 341.89, 341.89, 43, '2020-10-12 20:08:22.745507', null, 3, 2);
INSERT INTO public.product_deposit (id, average_price, price, quantity, created_at, updated_at, deposit_id, product_provider_id) VALUES (14, 339.00, 339.00, 29, '2020-10-12 20:08:22.745507', null, 3, 3);
INSERT INTO public.product_deposit (id, average_price, price, quantity, created_at, updated_at, deposit_id, product_provider_id) VALUES (15, 10288.00, 10288.00, 12, '2020-10-12 20:08:22.745507', null, 3, 4);
INSERT INTO public.product_deposit (id, average_price, price, quantity, created_at, updated_at, deposit_id, product_provider_id) VALUES (16, 10300.00, 10300.00, 1, '2020-10-12 20:08:22.745507', null, 3, 5);
INSERT INTO public.product_deposit (id, average_price, price, quantity, created_at, updated_at, deposit_id, product_provider_id) VALUES (17, 10588.00, 10588.00, 0, '2020-10-12 20:08:22.745507', null, 3, 6);
INSERT INTO public.product_deposit (id, average_price, price, quantity, created_at, updated_at, deposit_id, product_provider_id) VALUES (18, 4.76, 4.76, 79, '2020-10-12 20:08:22.745507', null, 3, 7);
INSERT INTO public.product_deposit (id, average_price, price, quantity, created_at, updated_at, deposit_id, product_provider_id) VALUES (19, 5.00, 5.00, 33, '2020-10-12 20:08:22.745507', null, 3, 8);
INSERT INTO public.product_deposit (id, average_price, price, quantity, created_at, updated_at, deposit_id, product_provider_id) VALUES (20, 4.76, 4.76, 213, '2020-10-12 20:08:22.745507', null, 3, 9);


INSERT INTO public.responsible ("name") VALUES('Larissa');
INSERT INTO public.responsible ("name") VALUES('Lucas');