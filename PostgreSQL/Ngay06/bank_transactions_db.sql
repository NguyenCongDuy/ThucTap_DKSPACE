--
-- PostgreSQL database dump
--

-- Dumped from database version 17.5
-- Dumped by pg_dump version 17.5

-- Started on 2025-06-23 17:57:05

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
-- TOC entry 218 (class 1259 OID 16668)
-- Name: accounts; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.accounts (
    account_id integer NOT NULL,
    account_holder character varying(100) NOT NULL,
    balance numeric(12,2) NOT NULL,
    CONSTRAINT accounts_balance_check CHECK ((balance >= (0)::numeric))
);


ALTER TABLE public.accounts OWNER TO postgres;

--
-- TOC entry 217 (class 1259 OID 16667)
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
-- TOC entry 4914 (class 0 OID 0)
-- Dependencies: 217
-- Name: accounts_account_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.accounts_account_id_seq OWNED BY public.accounts.account_id;


--
-- TOC entry 220 (class 1259 OID 16676)
-- Name: transactions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.transactions (
    transaction_id integer NOT NULL,
    from_account_id integer,
    to_account_id integer,
    amount numeric(12,2) NOT NULL,
    type character varying(20),
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT transactions_amount_check CHECK ((amount > (0)::numeric)),
    CONSTRAINT transactions_type_check CHECK (((type)::text = ANY ((ARRAY['TRANSFER'::character varying, 'DEPOSIT'::character varying, 'WITHDRAW'::character varying])::text[])))
);


ALTER TABLE public.transactions OWNER TO postgres;

--
-- TOC entry 219 (class 1259 OID 16675)
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
-- TOC entry 4915 (class 0 OID 0)
-- Dependencies: 219
-- Name: transactions_transaction_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.transactions_transaction_id_seq OWNED BY public.transactions.transaction_id;


--
-- TOC entry 4747 (class 2604 OID 16671)
-- Name: accounts account_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.accounts ALTER COLUMN account_id SET DEFAULT nextval('public.accounts_account_id_seq'::regclass);


--
-- TOC entry 4748 (class 2604 OID 16679)
-- Name: transactions transaction_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.transactions ALTER COLUMN transaction_id SET DEFAULT nextval('public.transactions_transaction_id_seq'::regclass);


--
-- TOC entry 4906 (class 0 OID 16668)
-- Dependencies: 218
-- Data for Name: accounts; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.accounts (account_id, account_holder, balance) FROM stdin;
3	Lê Văn C	3000.00
4	Phạm Thị D	7000.00
1	Nguyễn Văn A	4800.00
2	Trần Thị B	7100.00
\.


--
-- TOC entry 4908 (class 0 OID 16676)
-- Dependencies: 220
-- Data for Name: transactions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.transactions (transaction_id, from_account_id, to_account_id, amount, type, created_at) FROM stdin;
4	1	2	2000.00	TRANSFER	2025-06-23 10:36:01.599377
5	2	\N	1000.00	WITHDRAW	2025-06-23 10:36:01.599377
6	\N	3	1500.00	DEPOSIT	2025-06-23 10:36:01.599377
7	1	2	500.00	TRANSFER	2025-06-23 10:47:43.309398
8	1	2	500.00	TRANSFER	2025-06-23 10:47:55.760144
10	1	2	500.00	TRANSFER	2025-06-23 17:19:17.574865
11	1	2	500.00	TRANSFER	2025-06-23 17:23:36.348902
\.


--
-- TOC entry 4916 (class 0 OID 0)
-- Dependencies: 217
-- Name: accounts_account_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.accounts_account_id_seq', 4, true);


--
-- TOC entry 4917 (class 0 OID 0)
-- Dependencies: 219
-- Name: transactions_transaction_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.transactions_transaction_id_seq', 11, true);


--
-- TOC entry 4754 (class 2606 OID 16674)
-- Name: accounts accounts_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.accounts
    ADD CONSTRAINT accounts_pkey PRIMARY KEY (account_id);


--
-- TOC entry 4757 (class 2606 OID 16684)
-- Name: transactions transactions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.transactions
    ADD CONSTRAINT transactions_pkey PRIMARY KEY (transaction_id);


--
-- TOC entry 4755 (class 1259 OID 16695)
-- Name: idx_created_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_created_at ON public.transactions USING btree (created_at);


--
-- TOC entry 4758 (class 2606 OID 16685)
-- Name: transactions transactions_from_account_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.transactions
    ADD CONSTRAINT transactions_from_account_id_fkey FOREIGN KEY (from_account_id) REFERENCES public.accounts(account_id);


--
-- TOC entry 4759 (class 2606 OID 16690)
-- Name: transactions transactions_to_account_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.transactions
    ADD CONSTRAINT transactions_to_account_id_fkey FOREIGN KEY (to_account_id) REFERENCES public.accounts(account_id);


-- Completed on 2025-06-23 17:57:05

--
-- PostgreSQL database dump complete
--

