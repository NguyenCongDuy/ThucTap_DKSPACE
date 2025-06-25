--
-- PostgreSQL database dump
--

-- Dumped from database version 17.5
-- Dumped by pg_dump version 17.5

-- Started on 2025-06-24 14:00:15

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
-- TOC entry 4 (class 3079 OID 16827)
-- Name: pg_stat_statements; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pg_stat_statements WITH SCHEMA public;


--
-- TOC entry 5015 (class 0 OID 0)
-- Dependencies: 4
-- Name: EXTENSION pg_stat_statements; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pg_stat_statements IS 'track planning and execution statistics of all SQL statements executed';


--
-- TOC entry 3 (class 3079 OID 16790)
-- Name: pgcrypto; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pgcrypto WITH SCHEMA public;


--
-- TOC entry 5016 (class 0 OID 0)
-- Dependencies: 3
-- Name: EXTENSION pgcrypto; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pgcrypto IS 'cryptographic functions';


--
-- TOC entry 2 (class 3079 OID 16732)
-- Name: pgstattuple; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pgstattuple WITH SCHEMA public;


--
-- TOC entry 5017 (class 0 OID 0)
-- Dependencies: 2
-- Name: EXTENSION pgstattuple; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pgstattuple IS 'show tuple-level statistics';


--
-- TOC entry 288 (class 1255 OID 16866)
-- Name: transfer_money(uuid, uuid, numeric); Type: PROCEDURE; Schema: public; Owner: postgres
--

CREATE PROCEDURE public.transfer_money(IN sender uuid, IN receiver uuid, IN amount numeric)
    LANGUAGE plpgsql
    AS $$
DECLARE
    sender_balance DECIMAL;
BEGIN
    -- Khóa 2 dòng theo thứ tự để tránh deadlock
    PERFORM balance FROM accounts WHERE account_id = sender FOR UPDATE;
    PERFORM balance FROM accounts WHERE account_id = receiver FOR UPDATE;

    -- Kiểm tra số dư
    SELECT balance INTO sender_balance FROM accounts WHERE account_id = sender;
    IF sender_balance < amount THEN
        RAISE EXCEPTION 'Số dư không đủ.';
    END IF;

    -- Trừ tiền người gửi
    UPDATE accounts SET balance = balance - amount WHERE account_id = sender;

    -- Cộng tiền người nhận
    UPDATE accounts SET balance = balance + amount WHERE account_id = receiver;

    -- Ghi log giao dịch
    INSERT INTO transactions (transaction_id, account_id, amount, type, transaction_date, details)
    VALUES (
        gen_random_uuid(),
        sender,
        amount,
        'TRANSFER',
        NOW(),
        jsonb_build_object('recipient', receiver, 'note', 'Chuyển khoản tháng 6')
    );

END $$;


ALTER PROCEDURE public.transfer_money(IN sender uuid, IN receiver uuid, IN amount numeric) OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 221 (class 1259 OID 16704)
-- Name: accounts; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.accounts (
    account_id uuid NOT NULL,
    customer_id uuid,
    balance numeric(12,2),
    account_type character varying(20),
    created_at timestamp without time zone,
    CONSTRAINT accounts_account_type_check CHECK (((account_type)::text = ANY ((ARRAY['SAVINGS'::character varying, 'CHECKING'::character varying])::text[])))
);


ALTER TABLE public.accounts OWNER TO postgres;

--
-- TOC entry 220 (class 1259 OID 16697)
-- Name: customers; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.customers (
    customer_id uuid NOT NULL,
    full_name character varying(100),
    email character varying(100),
    created_at timestamp without time zone
);


ALTER TABLE public.customers OWNER TO postgres;

--
-- TOC entry 223 (class 1259 OID 16746)
-- Name: transactions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.transactions (
    transaction_id uuid NOT NULL,
    account_id uuid,
    amount numeric(12,2),
    type character varying(20),
    transaction_date timestamp without time zone NOT NULL,
    details jsonb,
    CONSTRAINT transactions_type_check1 CHECK (((type)::text = ANY ((ARRAY['DEPOSIT'::character varying, 'WITHDRAW'::character varying, 'TRANSFER'::character varying])::text[])))
)
PARTITION BY RANGE (transaction_date);


ALTER TABLE public.transactions OWNER TO postgres;

--
-- TOC entry 226 (class 1259 OID 16779)
-- Name: transactions_2023; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.transactions_2023 (
    transaction_id uuid NOT NULL,
    account_id uuid,
    amount numeric(12,2),
    type character varying(20),
    transaction_date timestamp without time zone NOT NULL,
    details jsonb,
    CONSTRAINT transactions_type_check1 CHECK (((type)::text = ANY ((ARRAY['DEPOSIT'::character varying, 'WITHDRAW'::character varying, 'TRANSFER'::character varying])::text[])))
);


ALTER TABLE public.transactions_2023 OWNER TO postgres;

--
-- TOC entry 225 (class 1259 OID 16768)
-- Name: transactions_2024; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.transactions_2024 (
    transaction_id uuid NOT NULL,
    account_id uuid,
    amount numeric(12,2),
    type character varying(20),
    transaction_date timestamp without time zone NOT NULL,
    details jsonb,
    CONSTRAINT transactions_type_check1 CHECK (((type)::text = ANY ((ARRAY['DEPOSIT'::character varying, 'WITHDRAW'::character varying, 'TRANSFER'::character varying])::text[])))
);


ALTER TABLE public.transactions_2024 OWNER TO postgres;

--
-- TOC entry 224 (class 1259 OID 16757)
-- Name: transactions_2025; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.transactions_2025 (
    transaction_id uuid NOT NULL,
    account_id uuid,
    amount numeric(12,2),
    type character varying(20),
    transaction_date timestamp without time zone NOT NULL,
    details jsonb,
    CONSTRAINT transactions_type_check1 CHECK (((type)::text = ANY ((ARRAY['DEPOSIT'::character varying, 'WITHDRAW'::character varying, 'TRANSFER'::character varying])::text[])))
);


ALTER TABLE public.transactions_2025 OWNER TO postgres;

--
-- TOC entry 222 (class 1259 OID 16715)
-- Name: transactions_old; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.transactions_old (
    transaction_id uuid NOT NULL,
    account_id uuid,
    amount numeric(12,2),
    type character varying(20),
    transaction_date timestamp without time zone,
    details jsonb,
    CONSTRAINT transactions_type_check CHECK (((type)::text = ANY ((ARRAY['DEPOSIT'::character varying, 'WITHDRAW'::character varying, 'TRANSFER'::character varying])::text[])))
);


ALTER TABLE public.transactions_old OWNER TO postgres;

--
-- TOC entry 4825 (class 0 OID 0)
-- Name: transactions_2023; Type: TABLE ATTACH; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.transactions ATTACH PARTITION public.transactions_2023 FOR VALUES FROM ('2023-01-01 00:00:00') TO ('2024-01-01 00:00:00');


--
-- TOC entry 4824 (class 0 OID 0)
-- Name: transactions_2024; Type: TABLE ATTACH; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.transactions ATTACH PARTITION public.transactions_2024 FOR VALUES FROM ('2024-01-01 00:00:00') TO ('2025-01-01 00:00:00');


--
-- TOC entry 4823 (class 0 OID 0)
-- Name: transactions_2025; Type: TABLE ATTACH; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.transactions ATTACH PARTITION public.transactions_2025 FOR VALUES FROM ('2025-01-01 00:00:00') TO ('2026-01-01 00:00:00');


--
-- TOC entry 5005 (class 0 OID 16704)
-- Dependencies: 221
-- Data for Name: accounts; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.accounts (account_id, customer_id, balance, account_type, created_at) FROM stdin;
11111111-2222-3333-4444-555566667777	a1b2c3d4-e5f6-7890-abcd-111122223333	5300.25	SAVINGS	2025-01-05 00:00:00
22222222-3333-4444-5555-666677778888	b2c3d4e5-f6a7-8901-bcde-222233334444	12000.50	CHECKING	2025-07-10 00:00:00
33333333-4444-5555-6666-777788889999	c3d4e5f6-a7b8-9012-cdef-333344445555	785.75	SAVINGS	2025-04-01 00:00:00
8105edfe-4732-46d3-b955-7f7dc6e6e9b4	d229623f-ee98-4b45-b002-c09bbc907332	1873.55	SAVINGS	2023-09-07 00:00:00
d7d00794-1ed9-4996-9118-cd139d24b4cb	d229623f-ee98-4b45-b002-c09bbc907332	10820.07	CHECKING	2024-06-18 00:00:00
\.


--
-- TOC entry 5004 (class 0 OID 16697)
-- Dependencies: 220
-- Data for Name: customers; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.customers (customer_id, full_name, email, created_at) FROM stdin;
d229623f-ee98-4b45-b002-c09bbc907332	Alice Smith	alicesmith@example.com	2024-07-15 00:00:00
f092b9bd-604d-433b-84b2-f32573062ca9	Bob Johnson	bobjohnson@example.com	2024-03-16 00:00:00
a1b2c3d4-e5f6-7890-abcd-111122223333	Tham ngoc	ngoct@gmail.com	2023-01-01 00:00:00
b2c3d4e5-f6a7-8901-bcde-222233334444	Pu Na	puna@gmail.com	2025-06-09 00:00:00
c3d4e5f6-a7b8-9012-cdef-333344445555	Anh A	anha@gmail.com	2025-05-22 00:00:00
\.


--
-- TOC entry 5009 (class 0 OID 16779)
-- Dependencies: 226
-- Data for Name: transactions_2023; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.transactions_2023 (transaction_id, account_id, amount, type, transaction_date, details) FROM stdin;
a1f1d49a-23c3-4d4a-8bfa-11e1cc202301	8105edfe-4732-46d3-b955-7f7dc6e6e9b4	1000.00	DEPOSIT	2023-08-15 00:00:00	{"note": "Gửi tiền", "recipient": "Self"}
\.


--
-- TOC entry 5008 (class 0 OID 16768)
-- Dependencies: 225
-- Data for Name: transactions_2024; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.transactions_2024 (transaction_id, account_id, amount, type, transaction_date, details) FROM stdin;
b2f1d49a-23c3-4d4a-8bfa-11e1cc202401	d7d00794-1ed9-4996-9118-cd139d24b4cb	500.00	WITHDRAW	2024-06-10 00:00:00	{"note": "Rút tiền ATM", "recipient": "Self"}
\.


--
-- TOC entry 5007 (class 0 OID 16757)
-- Dependencies: 224
-- Data for Name: transactions_2025; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.transactions_2025 (transaction_id, account_id, amount, type, transaction_date, details) FROM stdin;
c3f1d49a-23c3-4d4a-8bfa-11e1cc202501	8105edfe-4732-46d3-b955-7f7dc6e6e9b4	750.00	TRANSFER	2025-03-21 00:00:00	{"note": "Chuyển tiền học phí", "recipient": "University"}
2c4b0657-9a84-4242-aa2f-358b46c966f3	d7d00794-1ed9-4996-9118-cd139d24b4cb	100000.00	TRANSFER	2025-06-24 12:09:18.669125	{"note": "Monthly transfer", "recipient": "John Doe"}
cbee1303-3490-4acd-bbf8-5baf8a1abba0	d7d00794-1ed9-4996-9118-cd139d24b4cb	100000.00	TRANSFER	2025-06-24 13:31:34.114377	{"note": "Monthly transfer", "recipient": "John Doe"}
4018987e-6187-41bb-88f7-97c0ddd4b3a3	8105edfe-4732-46d3-b955-7f7dc6e6e9b4	500.00	TRANSFER	2025-06-24 13:49:35.620009	{"note": "Chuyển khoản tháng 6", "recipient": "d7d00794-1ed9-4996-9118-cd139d24b4cb"}
270825c9-cd2a-4f0d-b1cc-3bb4a1a2a12b	8105edfe-4732-46d3-b955-7f7dc6e6e9b4	500.00	TRANSFER	2025-06-24 13:50:30.096553	{"note": "Chuyển khoản tháng 6", "recipient": "d7d00794-1ed9-4996-9118-cd139d24b4cb"}
\.


--
-- TOC entry 5006 (class 0 OID 16715)
-- Dependencies: 222
-- Data for Name: transactions_old; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.transactions_old (transaction_id, account_id, amount, type, transaction_date, details) FROM stdin;
2d3b3e25-b860-477b-a80c-c126bedfc96d	8105edfe-4732-46d3-b955-7f7dc6e6e9b4	848.07	TRANSFER	2025-05-04 00:00:00	{"note": "Test transaction", "recipient": "Bob"}
2eb3f684-178b-4170-8864-b1a07979fba7	8105edfe-4732-46d3-b955-7f7dc6e6e9b4	441.00	DEPOSIT	2025-06-24 00:00:00	{"note": "Test transaction", "recipient": "Charlie"}
f1a67b9d-92ab-4b4c-92c7-7a1a899fb945	22222222-3333-4444-5555-666677778888	50.07	TRANSFER	2025-05-13 00:00:00	{"note": "Tra no", "recipient": "Bob"}
a3f9e6cd-bb41-4e10-8d99-2d12a6a63a57	33333333-4444-5555-6666-777788889999	44.00	DEPOSIT	2025-06-24 00:00:00	{"note": "Thanh toan tien nuoc", "recipient": "Charlie"}
\.


--
-- TOC entry 4837 (class 2606 OID 16709)
-- Name: accounts accounts_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.accounts
    ADD CONSTRAINT accounts_pkey PRIMARY KEY (account_id);


--
-- TOC entry 4833 (class 2606 OID 16703)
-- Name: customers customers_email_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.customers
    ADD CONSTRAINT customers_email_key UNIQUE (email);


--
-- TOC entry 4835 (class 2606 OID 16701)
-- Name: customers customers_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.customers
    ADD CONSTRAINT customers_pkey PRIMARY KEY (customer_id);


--
-- TOC entry 4844 (class 2606 OID 16751)
-- Name: transactions transactions_pkey1; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.transactions
    ADD CONSTRAINT transactions_pkey1 PRIMARY KEY (transaction_id, transaction_date);


--
-- TOC entry 4850 (class 2606 OID 16784)
-- Name: transactions_2023 transactions_2023_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.transactions_2023
    ADD CONSTRAINT transactions_2023_pkey PRIMARY KEY (transaction_id, transaction_date);


--
-- TOC entry 4848 (class 2606 OID 16773)
-- Name: transactions_2024 transactions_2024_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.transactions_2024
    ADD CONSTRAINT transactions_2024_pkey PRIMARY KEY (transaction_id, transaction_date);


--
-- TOC entry 4846 (class 2606 OID 16762)
-- Name: transactions_2025 transactions_2025_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.transactions_2025
    ADD CONSTRAINT transactions_2025_pkey PRIMARY KEY (transaction_id, transaction_date);


--
-- TOC entry 4842 (class 2606 OID 16722)
-- Name: transactions_old transactions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.transactions_old
    ADD CONSTRAINT transactions_pkey PRIMARY KEY (transaction_id);


--
-- TOC entry 4838 (class 1259 OID 16730)
-- Name: idx_account_date; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_account_date ON public.transactions_old USING btree (account_id, transaction_date);


--
-- TOC entry 4839 (class 1259 OID 16728)
-- Name: idx_transaction_date; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_transaction_date ON public.transactions_old USING btree (transaction_date);


--
-- TOC entry 4840 (class 1259 OID 16729)
-- Name: idx_transaction_details_gin; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_transaction_details_gin ON public.transactions_old USING gin (details);


--
-- TOC entry 4853 (class 0 OID 0)
-- Name: transactions_2023_pkey; Type: INDEX ATTACH; Schema: public; Owner: postgres
--

ALTER INDEX public.transactions_pkey1 ATTACH PARTITION public.transactions_2023_pkey;


--
-- TOC entry 4852 (class 0 OID 0)
-- Name: transactions_2024_pkey; Type: INDEX ATTACH; Schema: public; Owner: postgres
--

ALTER INDEX public.transactions_pkey1 ATTACH PARTITION public.transactions_2024_pkey;


--
-- TOC entry 4851 (class 0 OID 0)
-- Name: transactions_2025_pkey; Type: INDEX ATTACH; Schema: public; Owner: postgres
--

ALTER INDEX public.transactions_pkey1 ATTACH PARTITION public.transactions_2025_pkey;


--
-- TOC entry 4854 (class 2606 OID 16710)
-- Name: accounts accounts_customer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.accounts
    ADD CONSTRAINT accounts_customer_id_fkey FOREIGN KEY (customer_id) REFERENCES public.customers(customer_id);


--
-- TOC entry 4855 (class 2606 OID 16723)
-- Name: transactions_old transactions_account_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.transactions_old
    ADD CONSTRAINT transactions_account_id_fkey FOREIGN KEY (account_id) REFERENCES public.accounts(account_id);


--
-- TOC entry 4856 (class 2606 OID 16752)
-- Name: transactions transactions_account_id_fkey1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE public.transactions
    ADD CONSTRAINT transactions_account_id_fkey1 FOREIGN KEY (account_id) REFERENCES public.accounts(account_id);


-- Completed on 2025-06-24 14:00:15

--
-- PostgreSQL database dump complete
--

