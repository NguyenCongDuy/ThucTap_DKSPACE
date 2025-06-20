--
-- PostgreSQL database dump
--

-- Dumped from database version 17.5
-- Dumped by pg_dump version 17.5

-- Started on 2025-06-16 17:22:54

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
-- TOC entry 218 (class 1259 OID 16424)
-- Name: customers; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.customers (
    customer_id integer NOT NULL,
    full_name character varying(255),
    email character varying(255),
    phone character varying(20),
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.customers OWNER TO postgres;

--
-- TOC entry 217 (class 1259 OID 16423)
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
-- TOC entry 4912 (class 0 OID 0)
-- Dependencies: 217
-- Name: customers_customer_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.customers_customer_id_seq OWNED BY public.customers.customer_id;


--
-- TOC entry 220 (class 1259 OID 16434)
-- Name: transactions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.transactions (
    transaction_id integer NOT NULL,
    customer_id integer,
    amount numeric(12,2),
    type character varying(20),
    transaction_date timestamp without time zone,
    CONSTRAINT transactions_type_check CHECK (((type)::text = ANY ((ARRAY['DEPOSIT'::character varying, 'WITHDRAW'::character varying])::text[])))
);


ALTER TABLE public.transactions OWNER TO postgres;

--
-- TOC entry 219 (class 1259 OID 16433)
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
-- TOC entry 4913 (class 0 OID 0)
-- Dependencies: 219
-- Name: transactions_transaction_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.transactions_transaction_id_seq OWNED BY public.transactions.transaction_id;


--
-- TOC entry 4747 (class 2604 OID 16427)
-- Name: customers customer_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.customers ALTER COLUMN customer_id SET DEFAULT nextval('public.customers_customer_id_seq'::regclass);


--
-- TOC entry 4749 (class 2604 OID 16437)
-- Name: transactions transaction_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.transactions ALTER COLUMN transaction_id SET DEFAULT nextval('public.transactions_transaction_id_seq'::regclass);


--
-- TOC entry 4904 (class 0 OID 16424)
-- Dependencies: 218
-- Data for Name: customers; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.customers (customer_id, full_name, email, phone, created_at) FROM stdin;
3	Nguyen Thi C	nguyenthic_test02@gmail.com	0912345678	2024-05-10 00:00:00
4	Le Van D	levand_test99@outlook.com	\N	2024-03-15 00:00:00
5	Nguyen Van E	nguyenvane_test%abc@gmail.com	0987654321	2025-01-01 00:00:00
7	Nguyen Van A	nguyenvana@gmail.com	0912345678	2025-06-16 10:19:25.198917
8	Hoang Minh S	hoangg_test@gmail.com	0938123456	2025-06-16 16:58:38.18572
6	Pham thi F	phamf_test_test%xyz@gmail.com	\N	2025-03-05 00:00:00
1	Nguyen Van a	nguyenvana@gmail.com	0987654321	2024-01-05 00:00:00
2	Tran thi B		0988888888	2023-12-20 00:00:00
\.


--
-- TOC entry 4906 (class 0 OID 16434)
-- Dependencies: 220
-- Data for Name: transactions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.transactions (transaction_id, customer_id, amount, type, transaction_date) FROM stdin;
1	1	500.00	DEPOSIT	2024-01-10 00:00:00
2	1	2000.00	WITHDRAW	2024-02-20 00:00:00
3	2	1500.00	DEPOSIT	2025-03-15 00:00:00
5	3	2500.00	WITHDRAW	2024-06-25 00:00:00
7	5	1200.00	WITHDRAW	2025-04-01 00:00:00
9	6	3000.00	WITHDRAW	\N
\.


--
-- TOC entry 4914 (class 0 OID 0)
-- Dependencies: 217
-- Name: customers_customer_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.customers_customer_id_seq', 8, true);


--
-- TOC entry 4915 (class 0 OID 0)
-- Dependencies: 219
-- Name: transactions_transaction_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.transactions_transaction_id_seq', 10, true);


--
-- TOC entry 4752 (class 2606 OID 16432)
-- Name: customers customers_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.customers
    ADD CONSTRAINT customers_pkey PRIMARY KEY (customer_id);


--
-- TOC entry 4756 (class 2606 OID 16440)
-- Name: transactions transactions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.transactions
    ADD CONSTRAINT transactions_pkey PRIMARY KEY (transaction_id);


--
-- TOC entry 4753 (class 1259 OID 16447)
-- Name: idx_customer_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_customer_id ON public.transactions USING btree (customer_id);


--
-- TOC entry 4754 (class 1259 OID 16448)
-- Name: idx_transaction_date; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_transaction_date ON public.transactions USING btree (transaction_date);


--
-- TOC entry 4757 (class 2606 OID 16441)
-- Name: transactions transactions_customer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.transactions
    ADD CONSTRAINT transactions_customer_id_fkey FOREIGN KEY (customer_id) REFERENCES public.customers(customer_id);


-- Completed on 2025-06-16 17:22:54

--
-- PostgreSQL database dump complete
--

