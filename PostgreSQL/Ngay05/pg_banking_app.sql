--
-- PostgreSQL database dump
--

-- Dumped from database version 17.5
-- Dumped by pg_dump version 17.5

-- Started on 2025-06-20 06:15:25

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
-- TOC entry 240 (class 1255 OID 16658)
-- Name: log_account_changes(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.log_account_changes() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    IF TG_OP = 'INSERT' THEN
        INSERT INTO audit_log(table_name, operation, record_id, changed_at, old_data, new_data)
        VALUES (
            'accounts',
            'INSERT',
            NEW.account_id,
            NOW(),
            NULL,
            row_to_json(NEW)::jsonb
        );

    ELSIF TG_OP = 'UPDATE' THEN
        INSERT INTO audit_log(table_name, operation, record_id, changed_at, old_data, new_data)
        VALUES (
            'accounts',
            'UPDATE',
            NEW.account_id,
            NOW(),
            row_to_json(OLD)::jsonb,
            row_to_json(NEW)::jsonb
        );

    ELSIF TG_OP = 'DELETE' THEN
        INSERT INTO audit_log(table_name, operation, record_id, changed_at, old_data, new_data)
        VALUES (
            'accounts',
            'DELETE',
            OLD.account_id,
            NOW(),
            row_to_json(OLD)::jsonb,
            NULL
        );
    END IF;

    RETURN NULL;
END;
$$;


ALTER FUNCTION public.log_account_changes() OWNER TO postgres;

--
-- TOC entry 238 (class 1255 OID 16636)
-- Name: transfer_funds(integer, integer, numeric); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.transfer_funds(from_account_id integer, to_account_id integer, amount numeric) RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
    v_balance DECIMAL;
BEGIN
    -- Kiểm tra số dư tài khoản gửi
    SELECT balance INTO v_balance
    FROM accounts
    WHERE account_id = from_account_id;

    IF v_balance IS NULL THEN
        RAISE EXCEPTION 'Tài khoản gửi không tồn tại: %', from_account_id;
    ELSIF v_balance < amount THEN
        RAISE EXCEPTION 'Số dư không đủ trong tài khoản %', from_account_id;
    END IF;

    -- Trừ tiền tài khoản gửi
    UPDATE accounts
    SET balance = balance - amount,
        last_updated = NOW()
    WHERE account_id = from_account_id;

    -- Cộng tiền tài khoản nhận
    UPDATE accounts
    SET balance = balance + amount,
        last_updated = NOW()
    WHERE account_id = to_account_id;

    -- Ghi log vào bảng transactions
    INSERT INTO transactions(account_id, amount, type, transaction_date)
    VALUES 
        (from_account_id, -amount, 'TRANSFER', NOW()),
        (to_account_id, amount, 'TRANSFER', NOW());

    RAISE NOTICE 'Chuyển khoản thành công: từ % đến %, số tiền %', from_account_id, to_account_id, amount;

EXCEPTION
    WHEN OTHERS THEN
        RAISE NOTICE 'Lỗi xảy ra: %', SQLERRM;
        RAISE;
END;
$$;


ALTER FUNCTION public.transfer_funds(from_account_id integer, to_account_id integer, amount numeric) OWNER TO postgres;

--
-- TOC entry 239 (class 1255 OID 16637)
-- Name: update_customer_email(integer, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.update_customer_email(p_customer_id integer, p_new_email character varying) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
    -- Kiểm tra định dạng email
    IF POSITION('@' IN p_new_email) = 0 THEN
        RAISE EXCEPTION 'Email không hợp lệ: %', p_new_email;
    END IF;

    -- Cập nhật email
    UPDATE customers
    SET email = p_new_email
    WHERE customer_id = p_customer_id;

    RAISE NOTICE 'Email đã được cập nhật cho customer_id %', p_customer_id;
END;
$$;


ALTER FUNCTION public.update_customer_email(p_customer_id integer, p_new_email character varying) OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 220 (class 1259 OID 16597)
-- Name: accounts; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.accounts (
    account_id integer NOT NULL,
    customer_id integer,
    balance numeric(15,2) NOT NULL,
    account_type character varying(20),
    last_updated timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT accounts_account_type_check CHECK (((account_type)::text = ANY ((ARRAY['SAVINGS'::character varying, 'CHECKING'::character varying])::text[]))),
    CONSTRAINT accounts_balance_check CHECK ((balance >= (0)::numeric))
);


ALTER TABLE public.accounts OWNER TO postgres;

--
-- TOC entry 218 (class 1259 OID 16587)
-- Name: customers; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.customers (
    customer_id integer NOT NULL,
    full_name character varying(100) NOT NULL,
    email character varying(100) NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.customers OWNER TO postgres;

--
-- TOC entry 225 (class 1259 OID 16638)
-- Name: account_summary; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.account_summary AS
 SELECT c.full_name,
    c.email,
    a.account_id,
    a.balance,
    a.account_type
   FROM (public.customers c
     JOIN public.accounts a ON ((c.customer_id = a.customer_id)));


ALTER VIEW public.account_summary OWNER TO postgres;

--
-- TOC entry 219 (class 1259 OID 16596)
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
-- TOC entry 4953 (class 0 OID 0)
-- Dependencies: 219
-- Name: accounts_account_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.accounts_account_id_seq OWNED BY public.accounts.account_id;


--
-- TOC entry 224 (class 1259 OID 16627)
-- Name: audit_log; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.audit_log (
    log_id integer NOT NULL,
    table_name character varying(50),
    operation character varying(10),
    record_id integer,
    changed_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    old_data jsonb,
    new_data jsonb
);


ALTER TABLE public.audit_log OWNER TO postgres;

--
-- TOC entry 223 (class 1259 OID 16626)
-- Name: audit_log_log_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.audit_log_log_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.audit_log_log_id_seq OWNER TO postgres;

--
-- TOC entry 4954 (class 0 OID 0)
-- Dependencies: 223
-- Name: audit_log_log_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.audit_log_log_id_seq OWNED BY public.audit_log.log_id;


--
-- TOC entry 217 (class 1259 OID 16586)
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
-- TOC entry 4955 (class 0 OID 0)
-- Dependencies: 217
-- Name: customers_customer_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.customers_customer_id_seq OWNED BY public.customers.customer_id;


--
-- TOC entry 222 (class 1259 OID 16613)
-- Name: transactions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.transactions (
    transaction_id integer NOT NULL,
    account_id integer,
    amount numeric(15,2) NOT NULL,
    type character varying(20),
    transaction_date timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT transactions_type_check CHECK (((type)::text = ANY ((ARRAY['DEPOSIT'::character varying, 'WITHDRAW'::character varying, 'TRANSFER'::character varying])::text[])))
);


ALTER TABLE public.transactions OWNER TO postgres;

--
-- TOC entry 226 (class 1259 OID 16642)
-- Name: transaction_stats; Type: MATERIALIZED VIEW; Schema: public; Owner: postgres
--

CREATE MATERIALIZED VIEW public.transaction_stats AS
 SELECT account_id,
    type,
    count(*) AS total_transactions,
    sum(amount) AS total_amount
   FROM public.transactions
  GROUP BY account_id, type
  WITH NO DATA;


ALTER MATERIALIZED VIEW public.transaction_stats OWNER TO postgres;

--
-- TOC entry 221 (class 1259 OID 16612)
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
-- TOC entry 4956 (class 0 OID 0)
-- Dependencies: 221
-- Name: transactions_transaction_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.transactions_transaction_id_seq OWNED BY public.transactions.transaction_id;


--
-- TOC entry 4770 (class 2604 OID 16600)
-- Name: accounts account_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.accounts ALTER COLUMN account_id SET DEFAULT nextval('public.accounts_account_id_seq'::regclass);


--
-- TOC entry 4774 (class 2604 OID 16630)
-- Name: audit_log log_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.audit_log ALTER COLUMN log_id SET DEFAULT nextval('public.audit_log_log_id_seq'::regclass);


--
-- TOC entry 4768 (class 2604 OID 16590)
-- Name: customers customer_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.customers ALTER COLUMN customer_id SET DEFAULT nextval('public.customers_customer_id_seq'::regclass);


--
-- TOC entry 4772 (class 2604 OID 16616)
-- Name: transactions transaction_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.transactions ALTER COLUMN transaction_id SET DEFAULT nextval('public.transactions_transaction_id_seq'::regclass);


--
-- TOC entry 4942 (class 0 OID 16597)
-- Dependencies: 220
-- Data for Name: accounts; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.accounts (account_id, customer_id, balance, account_type, last_updated) FROM stdin;
3	2	12000.00	SAVINGS	2025-06-20 09:22:49.834222
4	3	500.00	CHECKING	2025-06-20 09:22:49.834222
2	1	6000.00	CHECKING	2025-06-20 05:54:58.951086
1	1	5200.00	SAVINGS	2025-06-20 05:54:58.951086
\.


--
-- TOC entry 4946 (class 0 OID 16627)
-- Dependencies: 224
-- Data for Name: audit_log; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.audit_log (log_id, table_name, operation, record_id, changed_at, old_data, new_data) FROM stdin;
1	accounts	UPDATE	1	2025-06-20 05:16:34.110763	{"balance": 3000.00, "account_id": 1, "customer_id": 1, "account_type": "SAVINGS", "last_updated": "2025-06-20T05:04:53.062279"}	{"balance": 3100.00, "account_id": 1, "customer_id": 1, "account_type": "SAVINGS", "last_updated": "2025-06-20T05:04:53.062279"}
2	accounts	UPDATE	2	2025-06-20 05:54:58.951086	{"balance": 8000.00, "account_id": 2, "customer_id": 1, "account_type": "CHECKING", "last_updated": "2025-06-20T05:04:53.062279"}	{"balance": 6000.00, "account_id": 2, "customer_id": 1, "account_type": "CHECKING", "last_updated": "2025-06-20T05:54:58.951086"}
3	accounts	UPDATE	1	2025-06-20 05:54:58.951086	{"balance": 3100.00, "account_id": 1, "customer_id": 1, "account_type": "SAVINGS", "last_updated": "2025-06-20T05:04:53.062279"}	{"balance": 5100.00, "account_id": 1, "customer_id": 1, "account_type": "SAVINGS", "last_updated": "2025-06-20T05:54:58.951086"}
4	accounts	UPDATE	1	2025-06-20 06:04:01.856442	{"balance": 5100.00, "account_id": 1, "customer_id": 1, "account_type": "SAVINGS", "last_updated": "2025-06-20T05:54:58.951086"}	{"balance": 5200.00, "account_id": 1, "customer_id": 1, "account_type": "SAVINGS", "last_updated": "2025-06-20T05:54:58.951086"}
\.


--
-- TOC entry 4940 (class 0 OID 16587)
-- Dependencies: 218
-- Data for Name: customers; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.customers (customer_id, full_name, email, created_at) FROM stdin;
3	Lê Văn C	c@outlook.com	2025-06-20 09:22:36.967899
1	Nguyễn Văn A	new_email@gmail.com	2025-06-20 09:22:36.967899
2	Trần Thị B	Clv@gmail.com	2025-06-20 09:22:36.967899
\.


--
-- TOC entry 4944 (class 0 OID 16613)
-- Dependencies: 222
-- Data for Name: transactions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.transactions (transaction_id, account_id, amount, type, transaction_date) FROM stdin;
8	1	5000.00	DEPOSIT	2025-06-20 09:23:03.346417
9	1	2000.00	WITHDRAW	2025-06-20 09:23:03.346417
10	2	1000.00	TRANSFER	2025-06-20 09:23:03.346417
11	3	200.00	DEPOSIT	2025-06-20 09:23:03.346417
12	3	100.00	WITHDRAW	2025-06-20 09:23:03.346417
13	4	50.00	DEPOSIT	2025-06-20 09:23:03.346417
14	1	2500.00	TRANSFER	2025-06-20 09:23:03.346417
15	1	-1000.00	TRANSFER	2025-06-20 09:52:21.233178
16	2	1000.00	TRANSFER	2025-06-20 09:52:21.233178
17	1	-1000.00	TRANSFER	2025-06-20 09:53:06.332929
18	2	1000.00	TRANSFER	2025-06-20 09:53:06.332929
19	1	-1000.00	TRANSFER	2025-06-20 09:53:53.114788
20	2	1000.00	TRANSFER	2025-06-20 09:53:53.114788
21	1	-2000.00	TRANSFER	2025-06-20 05:04:53.062279
22	2	2000.00	TRANSFER	2025-06-20 05:04:53.062279
23	2	-2000.00	TRANSFER	2025-06-20 05:54:58.951086
24	1	2000.00	TRANSFER	2025-06-20 05:54:58.951086
\.


--
-- TOC entry 4957 (class 0 OID 0)
-- Dependencies: 219
-- Name: accounts_account_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.accounts_account_id_seq', 4, true);


--
-- TOC entry 4958 (class 0 OID 0)
-- Dependencies: 223
-- Name: audit_log_log_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.audit_log_log_id_seq', 4, true);


--
-- TOC entry 4959 (class 0 OID 0)
-- Dependencies: 217
-- Name: customers_customer_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.customers_customer_id_seq', 3, true);


--
-- TOC entry 4960 (class 0 OID 0)
-- Dependencies: 221
-- Name: transactions_transaction_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.transactions_transaction_id_seq', 24, true);


--
-- TOC entry 4784 (class 2606 OID 16605)
-- Name: accounts accounts_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.accounts
    ADD CONSTRAINT accounts_pkey PRIMARY KEY (account_id);


--
-- TOC entry 4788 (class 2606 OID 16635)
-- Name: audit_log audit_log_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.audit_log
    ADD CONSTRAINT audit_log_pkey PRIMARY KEY (log_id);


--
-- TOC entry 4780 (class 2606 OID 16595)
-- Name: customers customers_email_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.customers
    ADD CONSTRAINT customers_email_key UNIQUE (email);


--
-- TOC entry 4782 (class 2606 OID 16593)
-- Name: customers customers_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.customers
    ADD CONSTRAINT customers_pkey PRIMARY KEY (customer_id);


--
-- TOC entry 4786 (class 2606 OID 16620)
-- Name: transactions transactions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.transactions
    ADD CONSTRAINT transactions_pkey PRIMARY KEY (transaction_id);


--
-- TOC entry 4791 (class 2620 OID 16659)
-- Name: accounts trigger_account_audit; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trigger_account_audit AFTER INSERT OR DELETE OR UPDATE ON public.accounts FOR EACH ROW EXECUTE FUNCTION public.log_account_changes();


--
-- TOC entry 4789 (class 2606 OID 16606)
-- Name: accounts accounts_customer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.accounts
    ADD CONSTRAINT accounts_customer_id_fkey FOREIGN KEY (customer_id) REFERENCES public.customers(customer_id);


--
-- TOC entry 4790 (class 2606 OID 16621)
-- Name: transactions transactions_account_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.transactions
    ADD CONSTRAINT transactions_account_id_fkey FOREIGN KEY (account_id) REFERENCES public.accounts(account_id);


--
-- TOC entry 4947 (class 0 OID 16642)
-- Dependencies: 226 4949
-- Name: transaction_stats; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: postgres
--

REFRESH MATERIALIZED VIEW public.transaction_stats;


-- Completed on 2025-06-20 06:15:25

--
-- PostgreSQL database dump complete
--

