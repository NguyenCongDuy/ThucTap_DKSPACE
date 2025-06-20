--
-- PostgreSQL database dump
--

-- Dumped from database version 17.5
-- Dumped by pg_dump version 17.5

-- Started on 2025-06-17 10:30:18

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

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 220 (class 1259 OID 16459)
-- Name: accounts; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.accounts (
    account_id integer NOT NULL,
    customer_id integer,
    balance numeric(15,2),
    account_type character varying(20),
    CONSTRAINT accounts_account_type_check CHECK (((account_type)::text = ANY ((ARRAY['SAVINGS'::character varying, 'CHECKING'::character varying])::text[])))
);


ALTER TABLE public.accounts OWNER TO postgres;

--
-- TOC entry 219 (class 1259 OID 16458)
-- Name: accounts_account_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.accounts_account_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.accounts_account_id_seq OWNER TO postgres;

--
-- TOC entry 4926 (class 0 OID 0)
-- Dependencies: 219
-- Name: accounts_account_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.accounts_account_id_seq OWNED BY public.accounts.account_id;


--
-- TOC entry 218 (class 1259 OID 16451)
-- Name: customers; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.customers (
    customer_id integer NOT NULL,
    full_name character varying(100),
    email character varying(100),
    created_at timestamp without time zone DEFAULT now()
);


ALTER TABLE public.customers OWNER TO postgres;

--
-- TOC entry 217 (class 1259 OID 16450)
-- Name: customers_customer_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.customers_customer_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.customers_customer_id_seq OWNER TO postgres;

--
-- TOC entry 4927 (class 0 OID 0)
-- Dependencies: 217
-- Name: customers_customer_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.customers_customer_id_seq OWNED BY public.customers.customer_id;


--
-- TOC entry 222 (class 1259 OID 16472)
-- Name: transactions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.transactions (
    transaction_id integer NOT NULL,
    account_id integer,
    amount numeric(15,2),
    type character varying(20),
    transaction_date timestamp without time zone DEFAULT now(),
    CONSTRAINT transactions_type_check CHECK (((type)::text = ANY ((ARRAY['DEPOSIT'::character varying, 'WITHDRAW'::character varying, 'TRANSFER'::character varying])::text[])))
);


ALTER TABLE public.transactions OWNER TO postgres;

--
-- TOC entry 221 (class 1259 OID 16471)
-- Name: transactions_transaction_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.transactions_transaction_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.transactions_transaction_id_seq OWNER TO postgres;

--
-- TOC entry 4928 (class 0 OID 0)
-- Dependencies: 221
-- Name: transactions_transaction_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.transactions_transaction_id_seq OWNED BY public.transactions.transaction_id;


--
-- TOC entry 4754 (class 2604 OID 16462)
-- Name: accounts account_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.accounts ALTER COLUMN account_id SET DEFAULT nextval('public.accounts_account_id_seq'::regclass);


--
-- TOC entry 4752 (class 2604 OID 16454)
-- Name: customers customer_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.customers ALTER COLUMN customer_id SET DEFAULT nextval('public.customers_customer_id_seq'::regclass);


--
-- TOC entry 4755 (class 2604 OID 16475)
-- Name: transactions transaction_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.transactions ALTER COLUMN transaction_id SET DEFAULT nextval('public.transactions_transaction_id_seq'::regclass);


--
-- TOC entry 4918 (class 0 OID 16459)
-- Dependencies: 220
-- Data for Name: accounts; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.accounts (account_id, customer_id, balance, account_type) FROM stdin;
1	1	10000.00	SAVINGS
2	1	15000.00	CHECKING
3	2	2000.00	SAVINGS
4	3	500.00	CHECKING
6	99	8000.00	SAVINGS
\.


--
-- TOC entry 4916 (class 0 OID 16451)
-- Dependencies: 218
-- Data for Name: customers; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.customers (customer_id, full_name, email, created_at) FROM stdin;
1	Nguyen Van A	a@gmail.com	2024-01-15 00:00:00
2	Tran Thi B	b@yahoo.com	2023-11-05 00:00:00
3	Le Van C	c@gmail.com	2024-05-10 00:00:00
4	Nguyễn Văn L	vanl@gmail.com	2025-06-17 09:10:46.814949
5	Hoang Minh X	minhx@gmail.com	2025-01-17 09:10:46.814
99	Le Thi Hoa	hoal@gmail.com	2025-03-17 09:10:46.814
\.


--
-- TOC entry 4920 (class 0 OID 16472)
-- Dependencies: 222
-- Data for Name: transactions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.transactions (transaction_id, account_id, amount, type, transaction_date) FROM stdin;
5	4	100.00	WITHDRAW	2024-06-10 00:00:00
6	1	3000.00	TRANSFER	2024-06-10 00:00:00
3	2	2000.00	TRANSFER	2025-05-15 00:00:00
4	3	1500.00	DEPOSIT	2025-03-10 00:00:00
1	1	1000.00	DEPOSIT	2025-06-17 00:00:00
2	1	300.00	WITHDRAW	2024-06-10 00:00:00
7	2	7000.00	DEPOSIT	2024-04-20 00:00:00
8	3	12000.00	WITHDRAW	2024-05-25 00:00:00
9	3	3000.00	DEPOSIT	2024-05-26 00:00:00
10	2	20000.00	TRANSFER	2024-06-12 00:00:00
16	1	1000.00	DEPOSIT	2024-03-01 00:00:00
17	2	1500.00	WITHDRAW	2024-03-05 00:00:00
18	3	2000.00	TRANSFER	2024-03-10 00:00:00
19	4	2500.00	DEPOSIT	2024-03-15 00:00:00
20	2	3000.00	WITHDRAW	2024-03-20 00:00:00
\.


--
-- TOC entry 4929 (class 0 OID 0)
-- Dependencies: 219
-- Name: accounts_account_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.accounts_account_id_seq', 6, true);


--
-- TOC entry 4930 (class 0 OID 0)
-- Dependencies: 217
-- Name: customers_customer_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.customers_customer_id_seq', 4, true);


--
-- TOC entry 4931 (class 0 OID 0)
-- Dependencies: 221
-- Name: transactions_transaction_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.transactions_transaction_id_seq', 20, true);


--
-- TOC entry 4762 (class 2606 OID 16465)
-- Name: accounts accounts_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.accounts
    ADD CONSTRAINT accounts_pkey PRIMARY KEY (account_id);


--
-- TOC entry 4760 (class 2606 OID 16457)
-- Name: customers customers_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.customers
    ADD CONSTRAINT customers_pkey PRIMARY KEY (customer_id);


--
-- TOC entry 4767 (class 2606 OID 16479)
-- Name: transactions transactions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.transactions
    ADD CONSTRAINT transactions_pkey PRIMARY KEY (transaction_id);


--
-- TOC entry 4764 (class 1259 OID 16486)
-- Name: idx_account_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_account_id ON public.transactions USING btree (account_id);


--
-- TOC entry 4763 (class 1259 OID 16485)
-- Name: idx_customer_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_customer_id ON public.accounts USING btree (customer_id);


--
-- TOC entry 4765 (class 1259 OID 16487)
-- Name: idx_transaction_date; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_transaction_date ON public.transactions USING btree (transaction_date);


--
-- TOC entry 4768 (class 2606 OID 16466)
-- Name: accounts accounts_customer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.accounts
    ADD CONSTRAINT accounts_customer_id_fkey FOREIGN KEY (customer_id) REFERENCES public.customers(customer_id);


--
-- TOC entry 4769 (class 2606 OID 16480)
-- Name: transactions transactions_account_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.transactions
    ADD CONSTRAINT transactions_account_id_fkey FOREIGN KEY (account_id) REFERENCES public.accounts(account_id);


-- Completed on 2025-06-17 10:30:18

--
-- PostgreSQL database dump complete
--

