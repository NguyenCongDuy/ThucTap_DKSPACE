--
-- PostgreSQL database dump
--

-- Dumped from database version 17.5
-- Dumped by pg_dump version 17.5

-- Started on 2025-06-25 17:44:22

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 3 (class 3079 OID 17024)
-- Name: pg_stat_statements; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pg_stat_statements WITH SCHEMA public;


--
-- TOC entry 4983 (class 0 OID 0)
-- Dependencies: 3
-- Name: EXTENSION pg_stat_statements; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pg_stat_statements IS 'track planning and execution statistics of all SQL statements executed';


--
-- TOC entry 2 (class 3079 OID 16868)
-- Name: uuid-ossp; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA public;


--
-- TOC entry 4984 (class 0 OID 0)
-- Dependencies: 2
-- Name: EXTENSION "uuid-ossp"; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION "uuid-ossp" IS 'generate universally unique identifiers (UUIDs)';


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 224 (class 1259 OID 16888)
-- Name: accounts; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.accounts (
    account_id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    customer_id uuid,
    balance numeric(12,2),
    account_type character varying(20),
    opened_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT accounts_account_type_check CHECK (((account_type)::text = ANY ((ARRAY['SAVINGS'::character varying, 'CHECKING'::character varying])::text[]))),
    CONSTRAINT accounts_balance_check CHECK ((balance >= (0)::numeric))
);


ALTER TABLE public.accounts OWNER TO postgres;

--
-- TOC entry 223 (class 1259 OID 16879)
-- Name: customers; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.customers (
    customer_id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    full_name character varying(100) NOT NULL,
    email character varying(255) NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.customers OWNER TO postgres;

--
-- TOC entry 227 (class 1259 OID 17102)
-- Name: transactions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.transactions (
    transaction_id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    account_id uuid,
    amount numeric(12,2) NOT NULL,
    type character varying(20),
    transaction_date timestamp without time zone NOT NULL,
    metadata jsonb,
    CONSTRAINT transactions_amount_check CHECK ((amount >= (0)::numeric)),
    CONSTRAINT transactions_type_check CHECK (((type)::text = ANY ((ARRAY['DEPOSIT'::character varying, 'WITHDRAW'::character varying, 'TRANSFER'::character varying])::text[])))
)
PARTITION BY RANGE (transaction_date);


ALTER TABLE public.transactions OWNER TO postgres;

--
-- TOC entry 228 (class 1259 OID 17115)
-- Name: transactions_2023; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.transactions_2023 (
    transaction_id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    account_id uuid,
    amount numeric(12,2) NOT NULL,
    type character varying(20),
    transaction_date timestamp without time zone NOT NULL,
    metadata jsonb,
    CONSTRAINT transactions_amount_check CHECK ((amount >= (0)::numeric)),
    CONSTRAINT transactions_type_check CHECK (((type)::text = ANY ((ARRAY['DEPOSIT'::character varying, 'WITHDRAW'::character varying, 'TRANSFER'::character varying])::text[])))
);


ALTER TABLE public.transactions_2023 OWNER TO postgres;

--
-- TOC entry 229 (class 1259 OID 17128)
-- Name: transactions_2024; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.transactions_2024 (
    transaction_id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    account_id uuid,
    amount numeric(12,2) NOT NULL,
    type character varying(20),
    transaction_date timestamp without time zone NOT NULL,
    metadata jsonb,
    CONSTRAINT transactions_amount_check CHECK ((amount >= (0)::numeric)),
    CONSTRAINT transactions_type_check CHECK (((type)::text = ANY ((ARRAY['DEPOSIT'::character varying, 'WITHDRAW'::character varying, 'TRANSFER'::character varying])::text[])))
);


ALTER TABLE public.transactions_2024 OWNER TO postgres;

--
-- TOC entry 230 (class 1259 OID 17141)
-- Name: transactions_2025; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.transactions_2025 (
    transaction_id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    account_id uuid,
    amount numeric(12,2) NOT NULL,
    type character varying(20),
    transaction_date timestamp without time zone NOT NULL,
    metadata jsonb,
    CONSTRAINT transactions_amount_check CHECK ((amount >= (0)::numeric)),
    CONSTRAINT transactions_type_check CHECK (((type)::text = ANY ((ARRAY['DEPOSIT'::character varying, 'WITHDRAW'::character varying, 'TRANSFER'::character varying])::text[])))
);


ALTER TABLE public.transactions_2025 OWNER TO postgres;

--
-- TOC entry 4786 (class 0 OID 0)
-- Name: transactions_2023; Type: TABLE ATTACH; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.transactions ATTACH PARTITION public.transactions_2023 FOR VALUES FROM ('2023-01-01 00:00:00') TO ('2024-01-01 00:00:00');


--
-- TOC entry 4787 (class 0 OID 0)
-- Name: transactions_2024; Type: TABLE ATTACH; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.transactions ATTACH PARTITION public.transactions_2024 FOR VALUES FROM ('2024-01-01 00:00:00') TO ('2025-01-01 00:00:00');


--
-- TOC entry 4788 (class 0 OID 0)
-- Name: transactions_2025; Type: TABLE ATTACH; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.transactions ATTACH PARTITION public.transactions_2025 FOR VALUES FROM ('2025-01-01 00:00:00') TO ('2026-01-01 00:00:00');


--
-- TOC entry 4974 (class 0 OID 16888)
-- Dependencies: 224
-- Data for Name: accounts; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.accounts (account_id, customer_id, balance, account_type, opened_at) FROM stdin;
c2fe347b-75a9-4a01-8343-56b5caab138f	79b279da-711f-4695-868d-5f0ab0e5d8c3	92000.00	SAVINGS	2023-01-01 00:00:00
5903c2fa-7190-40c9-8846-1c653e4f86bb	443a76d9-8385-4f5b-a5bf-9a6b7fff39e6	5000.00	SAVINGS	2023-01-01 00:00:00
e244ef87-7729-43ba-9945-3a19b43113c8	cb285fab-1bcf-4d1d-ad50-bde776f9580e	75000.00	SAVINGS	2023-01-01 00:00:00
143a4c29-762d-41e8-94c1-993c2b49d350	0daf70e4-870f-44d0-bfad-4fb751464348	34000.00	SAVINGS	2023-01-01 00:00:00
94ff2b84-d9da-45ff-ac19-da1f71743d93	7da2ad48-4fb1-4836-9645-16d904cf8495	65000.00	SAVINGS	2023-01-01 00:00:00
2c8f12cb-d3c8-4731-9749-48d82c50d860	2646e72e-c560-4862-b495-b64ffad96429	12000.00	SAVINGS	2023-01-01 00:00:00
c92a69f1-89ab-4fb9-b21f-2c51a5884bdd	039c5f19-095c-46f8-befb-adce16c7d05a	5000.00	SAVINGS	2023-01-01 00:00:00
ee8eb7e1-d3e8-4fb4-98c6-e9008064a603	7a3397a7-f78e-45ce-a60c-43e483dada95	15000.00	SAVINGS	2023-01-01 00:00:00
ffa9610c-deef-484a-b77e-40b29d5ba4f7	95b942f8-75aa-41dd-a7e7-ffb599f67b39	10000.00	SAVINGS	2023-01-01 00:00:00
4fcdebed-c7c7-49bf-a066-2a0242c3ca03	535e7182-ee3f-48f0-98b8-502fc8f8c666	6000.00	SAVINGS	2023-01-01 00:00:00
\.


--
-- TOC entry 4973 (class 0 OID 16879)
-- Dependencies: 223
-- Data for Name: customers; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.customers (customer_id, full_name, email, created_at) FROM stdin;
95b942f8-75aa-41dd-a7e7-ffb599f67b39	Nguyễn Thị Ánh	anh.nguyen@gmail.com	2023-01-15 00:00:00
535e7182-ee3f-48f0-98b8-502fc8f8c666	Trần Văn Bảo	bao.tran@gmail.com	2023-02-20 00:00:00
79b279da-711f-4695-868d-5f0ab0e5d8c3	Lê Thị Cẩm	cam.le@gmail.com	2023-03-01 00:00:00
443a76d9-8385-4f5b-a5bf-9a6b7fff39e6	Phạm Minh Dũng	dung.pham@gmail.com	2023-04-10 00:00:00
cb285fab-1bcf-4d1d-ad50-bde776f9580e	Đặng Thị Em	em.dang@gmail.com	2024-05-05 00:00:00
0daf70e4-870f-44d0-bfad-4fb751464348	Bùi Quốc Phong	phong.bui@gmail.com	2024-06-01 00:00:00
7da2ad48-4fb1-4836-9645-16d904cf8495	Hoàng Ngọc Giàu	giau.hoang@gmail.com	2025-01-15 00:00:00
2646e72e-c560-4862-b495-b64ffad96429	Võ Thành Hưng	hung.vo@gmail.com	2025-02-10 00:00:00
039c5f19-095c-46f8-befb-adce16c7d05a	Châu Mỹ Linh	linh.chau@gmail.com	2025-03-03 00:00:00
7a3397a7-f78e-45ce-a60c-43e483dada95	Lâm Hoài Nam	nam.lam@gmail.com	2025-04-12 00:00:00
\.


--
-- TOC entry 4975 (class 0 OID 17115)
-- Dependencies: 228
-- Data for Name: transactions_2023; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.transactions_2023 (transaction_id, account_id, amount, type, transaction_date, metadata) FROM stdin;
5b6d9409-6761-4932-8459-4e4e84755bbe	c2fe347b-75a9-4a01-8343-56b5caab138f	500.00	DEPOSIT	2023-03-01 00:00:00	{"source": "Mobile", "location": "Hanoi"}
f82b2cec-a433-47f4-9549-be8fc1f26de5	5903c2fa-7190-40c9-8846-1c653e4f86bb	500.00	DEPOSIT	2023-03-01 00:00:00	{"source": "Mobile", "location": "Hanoi"}
c8f60333-71e3-4d37-8a76-6841086a9d08	e244ef87-7729-43ba-9945-3a19b43113c8	500.00	DEPOSIT	2023-03-01 00:00:00	{"source": "Mobile", "location": "Hanoi"}
2ae4b00b-aec4-4bc8-a4a2-2e04765c7fd8	143a4c29-762d-41e8-94c1-993c2b49d350	500.00	DEPOSIT	2023-03-01 00:00:00	{"source": "Mobile", "location": "Hanoi"}
b97e0ee8-69fe-47da-92a8-06556690e218	94ff2b84-d9da-45ff-ac19-da1f71743d93	500.00	DEPOSIT	2023-03-01 00:00:00	{"source": "Mobile", "location": "Hanoi"}
\.


--
-- TOC entry 4976 (class 0 OID 17128)
-- Dependencies: 229
-- Data for Name: transactions_2024; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.transactions_2024 (transaction_id, account_id, amount, type, transaction_date, metadata) FROM stdin;
4758409a-4067-4d40-ab7f-81812e70a24d	c2fe347b-75a9-4a01-8343-56b5caab138f	800.00	TRANSFER	2024-06-01 00:00:00	{"fee": 0, "device": "VietinBank", "source": "ATM"}
bc543d56-67cc-4610-9d16-14186587f7ac	5903c2fa-7190-40c9-8846-1c653e4f86bb	800.00	TRANSFER	2024-06-01 00:00:00	{"fee": 0, "device": "VietinBank", "source": "ATM"}
a1721c34-efef-483b-98fa-6f80e1450b3b	e244ef87-7729-43ba-9945-3a19b43113c8	800.00	TRANSFER	2024-06-01 00:00:00	{"fee": 0, "device": "VietinBank", "source": "ATM"}
78f0d9c8-509b-45de-ab10-e39e16be0ffd	143a4c29-762d-41e8-94c1-993c2b49d350	800.00	TRANSFER	2024-06-01 00:00:00	{"fee": 0, "device": "VietinBank", "source": "ATM"}
1298632f-87a1-4bf0-b4ef-79870ae6ae51	94ff2b84-d9da-45ff-ac19-da1f71743d93	800.00	TRANSFER	2024-06-01 00:00:00	{"fee": 0, "device": "VietinBank", "source": "ATM"}
\.


--
-- TOC entry 4977 (class 0 OID 17141)
-- Dependencies: 230
-- Data for Name: transactions_2025; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.transactions_2025 (transaction_id, account_id, amount, type, transaction_date, metadata) FROM stdin;
a1ba809e-d2e0-4b9d-ba7d-c1a8cceb4a4e	c2fe347b-75a9-4a01-8343-56b5caab138f	1000.00	DEPOSIT	2025-02-01 00:00:00	{"ip": "192.168.1.0", "source": "Internet Banking"}
c3589ad8-9ef1-4ad8-b809-8abee6b48e5e	5903c2fa-7190-40c9-8846-1c653e4f86bb	1000.00	DEPOSIT	2025-02-01 00:00:00	{"ip": "192.168.1.0", "source": "Internet Banking"}
b8dd7924-9eb1-4ec8-af0f-514b8a9bdf25	e244ef87-7729-43ba-9945-3a19b43113c8	1000.00	DEPOSIT	2025-02-01 00:00:00	{"ip": "192.168.1.0", "source": "Internet Banking"}
1e9ad171-4f67-4e40-ae8e-5a4b83d080b7	143a4c29-762d-41e8-94c1-993c2b49d350	1000.00	DEPOSIT	2025-02-01 00:00:00	{"ip": "192.168.1.0", "source": "Internet Banking"}
e0166ad3-211f-4871-8118-81558842620a	94ff2b84-d9da-45ff-ac19-da1f71743d93	1000.00	DEPOSIT	2025-02-01 00:00:00	{"ip": "192.168.1.0", "source": "Internet Banking"}
9fcdf416-c12c-4609-b399-7abd040ec461	c2fe347b-75a9-4a01-8343-56b5caab138f	15.00	DEPOSIT	2025-06-25 17:10:19.546809	{"source": "ATM", "location": "HCM"}
3ac83370-03a9-4781-9fbe-143c791f30ed	ffa9610c-deef-484a-b77e-40b29d5ba4f7	1000.00	TRANSFER	2025-06-25 17:21:33.656913	{"to": "4fcdebed-c7c7-49bf-a066-2a0242c3ca03", "direction": "out"}
1b608ce8-6d74-47e5-8afb-2a355d003a87	4fcdebed-c7c7-49bf-a066-2a0242c3ca03	1000.00	TRANSFER	2025-06-25 17:21:33.656913	{"from": "ffa9610c-deef-484a-b77e-40b29d5ba4f7", "direction": "in"}
\.


--
-- TOC entry 4812 (class 2606 OID 16896)
-- Name: accounts accounts_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.accounts
    ADD CONSTRAINT accounts_pkey PRIMARY KEY (account_id);


--
-- TOC entry 4808 (class 2606 OID 16887)
-- Name: customers customers_email_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.customers
    ADD CONSTRAINT customers_email_key UNIQUE (email);


--
-- TOC entry 4810 (class 2606 OID 16885)
-- Name: customers customers_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.customers
    ADD CONSTRAINT customers_pkey PRIMARY KEY (customer_id);


--
-- TOC entry 4814 (class 2606 OID 17109)
-- Name: transactions transactions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.transactions
    ADD CONSTRAINT transactions_pkey PRIMARY KEY (transaction_id, transaction_date);


--
-- TOC entry 4816 (class 2606 OID 17122)
-- Name: transactions_2023 transactions_2023_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.transactions_2023
    ADD CONSTRAINT transactions_2023_pkey PRIMARY KEY (transaction_id, transaction_date);


--
-- TOC entry 4818 (class 2606 OID 17135)
-- Name: transactions_2024 transactions_2024_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.transactions_2024
    ADD CONSTRAINT transactions_2024_pkey PRIMARY KEY (transaction_id, transaction_date);


--
-- TOC entry 4820 (class 2606 OID 17148)
-- Name: transactions_2025 transactions_2025_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.transactions_2025
    ADD CONSTRAINT transactions_2025_pkey PRIMARY KEY (transaction_id, transaction_date);


--
-- TOC entry 4821 (class 0 OID 0)
-- Name: transactions_2023_pkey; Type: INDEX ATTACH; Schema: public; Owner: postgres
--

ALTER INDEX public.transactions_pkey ATTACH PARTITION public.transactions_2023_pkey;


--
-- TOC entry 4822 (class 0 OID 0)
-- Name: transactions_2024_pkey; Type: INDEX ATTACH; Schema: public; Owner: postgres
--

ALTER INDEX public.transactions_pkey ATTACH PARTITION public.transactions_2024_pkey;


--
-- TOC entry 4823 (class 0 OID 0)
-- Name: transactions_2025_pkey; Type: INDEX ATTACH; Schema: public; Owner: postgres
--

ALTER INDEX public.transactions_pkey ATTACH PARTITION public.transactions_2025_pkey;


--
-- TOC entry 4824 (class 2606 OID 16897)
-- Name: accounts accounts_customer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.accounts
    ADD CONSTRAINT accounts_customer_id_fkey FOREIGN KEY (customer_id) REFERENCES public.customers(customer_id);


--
-- TOC entry 4825 (class 2606 OID 17110)
-- Name: transactions transactions_account_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE public.transactions
    ADD CONSTRAINT transactions_account_id_fkey FOREIGN KEY (account_id) REFERENCES public.accounts(account_id);


-- Completed on 2025-06-25 17:44:22

--
-- PostgreSQL database dump complete
--

