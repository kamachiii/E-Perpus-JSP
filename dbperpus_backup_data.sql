--
-- PostgreSQL database dump
--


-- Dumped from database version 18.1
-- Dumped by pg_dump version 18.1

-- Started on 2026-01-16 06:39:14

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
-- TOC entry 229 (class 1259 OID 24947)
-- Name: bookmarks; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.bookmarks (
    user_id integer NOT NULL,
    book_id integer NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.bookmarks OWNER TO postgres;

--
-- TOC entry 224 (class 1259 OID 24889)
-- Name: books; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.books (
    id integer NOT NULL,
    title character varying(200) NOT NULL,
    author character varying(100),
    publisher character varying(100),
    year integer,
    stock integer DEFAULT 0,
    cover_image character varying(255),
    category_id integer
);


ALTER TABLE public.books OWNER TO postgres;

--
-- TOC entry 223 (class 1259 OID 24888)
-- Name: books_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.books_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.books_id_seq OWNER TO postgres;

--
-- TOC entry 5081 (class 0 OID 0)
-- Dependencies: 223
-- Name: books_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.books_id_seq OWNED BY public.books.id;


--
-- TOC entry 222 (class 1259 OID 24878)
-- Name: categories; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.categories (
    id integer NOT NULL,
    name character varying(50) NOT NULL
);


ALTER TABLE public.categories OWNER TO postgres;

--
-- TOC entry 221 (class 1259 OID 24877)
-- Name: categories_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.categories_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.categories_id_seq OWNER TO postgres;

--
-- TOC entry 5082 (class 0 OID 0)
-- Dependencies: 221
-- Name: categories_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.categories_id_seq OWNED BY public.categories.id;


--
-- TOC entry 226 (class 1259 OID 24906)
-- Name: loans; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.loans (
    id integer NOT NULL,
    user_id integer,
    book_id integer,
    loan_date date DEFAULT CURRENT_DATE,
    due_date date,
    return_date date,
    status character varying(20) DEFAULT 'borrowed'::character varying
);


ALTER TABLE public.loans OWNER TO postgres;

--
-- TOC entry 225 (class 1259 OID 24905)
-- Name: loans_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.loans_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.loans_id_seq OWNER TO postgres;

--
-- TOC entry 5083 (class 0 OID 0)
-- Dependencies: 225
-- Name: loans_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.loans_id_seq OWNED BY public.loans.id;


--
-- TOC entry 228 (class 1259 OID 24926)
-- Name: reviews; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.reviews (
    id integer NOT NULL,
    user_id integer,
    book_id integer,
    rating integer,
    comment text,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT reviews_rating_check CHECK (((rating >= 1) AND (rating <= 5)))
);


ALTER TABLE public.reviews OWNER TO postgres;

--
-- TOC entry 227 (class 1259 OID 24925)
-- Name: reviews_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.reviews_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.reviews_id_seq OWNER TO postgres;

--
-- TOC entry 5084 (class 0 OID 0)
-- Dependencies: 227
-- Name: reviews_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.reviews_id_seq OWNED BY public.reviews.id;


--
-- TOC entry 220 (class 1259 OID 24864)
-- Name: users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.users (
    id integer NOT NULL,
    username character varying(50) NOT NULL,
    password character varying(255) NOT NULL,
    full_name character varying(100),
    role character varying(20),
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    email character varying(100) NOT NULL,
    CONSTRAINT users_role_check CHECK (((role)::text = ANY ((ARRAY['admin'::character varying, 'member'::character varying])::text[])))
);


ALTER TABLE public.users OWNER TO postgres;

--
-- TOC entry 219 (class 1259 OID 24863)
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.users_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.users_id_seq OWNER TO postgres;

--
-- TOC entry 5085 (class 0 OID 0)
-- Dependencies: 219
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- TOC entry 4883 (class 2604 OID 24892)
-- Name: books id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.books ALTER COLUMN id SET DEFAULT nextval('public.books_id_seq'::regclass);


--
-- TOC entry 4882 (class 2604 OID 24881)
-- Name: categories id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.categories ALTER COLUMN id SET DEFAULT nextval('public.categories_id_seq'::regclass);


--
-- TOC entry 4885 (class 2604 OID 24909)
-- Name: loans id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.loans ALTER COLUMN id SET DEFAULT nextval('public.loans_id_seq'::regclass);


--
-- TOC entry 4888 (class 2604 OID 24929)
-- Name: reviews id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.reviews ALTER COLUMN id SET DEFAULT nextval('public.reviews_id_seq'::regclass);


--
-- TOC entry 4880 (class 2604 OID 24867)
-- Name: users id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- TOC entry 5075 (class 0 OID 24947)
-- Dependencies: 229
-- Data for Name: bookmarks; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.bookmarks VALUES (1, 1, '2026-01-15 19:25:28.85518');
INSERT INTO public.bookmarks VALUES (1, 5, '2026-01-16 06:15:36.968899');


--
-- TOC entry 5070 (class 0 OID 24889)
-- Dependencies: 224
-- Data for Name: books; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.books VALUES (1, 'Hujan', 'Tere Liye', 'Gramedia', 2016, 11, '1-Hujan-Gramedia-2016.jpg', 2);
INSERT INTO public.books VALUES (5, 'Bumi', 'Tere Liye', 'Gramedia', 2022, 15, '5-Bumi-Gramedia-2022.png', 2);
INSERT INTO public.books VALUES (6, 'Bulan', 'Tere Liye', 'Gramedia', 2022, 10, '6-Bulan-Gramedia-2022.jpg', 2);
INSERT INTO public.books VALUES (7, 'Matahari', 'Tere Liye', 'Gramedia', 2022, 14, '7-Matahari-Gramedia-2022.jpg', 2);
INSERT INTO public.books VALUES (8, 'Langkah Mudah Belajar Pemrograman PHP Menggunakan CodeIgniter 4 Untuk Pemula', 'Randi Andrika Putra', 'Anak Hebat Indonesia', 2025, 3, '8-Langkah-Mudah-Belajar-Pemrograman-PHP-Menggunakan-CodeIgniter-4-Untuk-Pemula-Anak-Hebat-Indonesia-2025.jpg', 1);
INSERT INTO public.books VALUES (9, 'Langkah Mudah Belajar Machine Learning dengan Python untuk Pemula', 'Randi Andrika Putra', 'Anak Hebat Indonesia', 2024, 8, '9-Langkah-Mudah-Belajar-Machine-Learning-dengan-Python-untuk-Pemula-Anak-Hebat-Indonesia-2024.jpg', 1);
INSERT INTO public.books VALUES (10, 'The Art of Stoicism', 'Adora Kinara', 'Jendela Penerbit', 2024, 20, '10-The-Art-of-Stoicism-Jendela-Penerbit-2024.jpg', 5);
INSERT INTO public.books VALUES (11, '10 Dosa Besar Soeharto', 'Wimanjaya K. Liotohe', 'Upaya Warga Negara', 1998, 2, '11-10-Dosa-Besar-Soeharto-Upaya-Warga-Negara-1998.jpg', 3);


--
-- TOC entry 5068 (class 0 OID 24878)
-- Dependencies: 222
-- Data for Name: categories; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.categories VALUES (1, 'Technology');
INSERT INTO public.categories VALUES (2, 'Fiction');
INSERT INTO public.categories VALUES (3, 'History');
INSERT INTO public.categories VALUES (4, 'Science');
INSERT INTO public.categories VALUES (5, 'Self Help');


--
-- TOC entry 5072 (class 0 OID 24906)
-- Dependencies: 226
-- Data for Name: loans; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.loans VALUES (1, 1, 1, '2026-01-15', '2026-01-22', '2026-01-15', 'returned');
INSERT INTO public.loans VALUES (2, 1, 1, '2025-01-15', '2025-01-22', '2026-01-15', 'returned');
INSERT INTO public.loans VALUES (3, 1, 1, '2026-01-15', '2026-01-22', '2026-01-15', 'returned');
INSERT INTO public.loans VALUES (4, 1, 1, '2026-01-15', '2026-01-22', '2026-01-15', 'returned');
INSERT INTO public.loans VALUES (5, 1, 1, '2026-01-15', '2026-01-22', NULL, 'borrowed');


--
-- TOC entry 5074 (class 0 OID 24926)
-- Dependencies: 228
-- Data for Name: reviews; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.reviews VALUES (1, 1, 1, 5, 'keren bangett', '2026-01-15 20:11:19.672628');
INSERT INTO public.reviews VALUES (2, 4, 1, 4, 'Masih lebih bagus one piece', '2026-01-16 05:43:48.783787');


--
-- TOC entry 5066 (class 0 OID 24864)
-- Dependencies: 220
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.users VALUES (1, 'kamachiii', '$2a$12$YHUXAZ7hsJQF0q7yN34Rq.aQ2Ni8sHSfot7T90dc3mohT3Zslrn6y', 'Tamuramaro Kamachi', 'member', '2026-01-10 15:59:51.906589', 'kamachi@app.com');
INSERT INTO public.users VALUES (2, 'admin', '$2a$12$b2ImfpK.lrv55214I7zCvOcJl8HvU7XuDfPyYe/brbg.GupSzeriy', 'admin', 'admin', '2026-01-15 12:03:19.135589', 'admin@app.com');
INSERT INTO public.users VALUES (3, 'kamil_kamachiii', '$2a$12$.4GSOel2hbP19M0JLrs1nuUuSKF4a6KRao4o/yggz6j9739gw5wJC', 'Muhammad Kamil', 'member', '2026-01-16 05:43:17.781229', '0110224094@student.nurulfikri.ac.id');


--
-- TOC entry 5086 (class 0 OID 0)
-- Dependencies: 223
-- Name: books_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.books_id_seq', 11, true);


--
-- TOC entry 5087 (class 0 OID 0)
-- Dependencies: 221
-- Name: categories_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.categories_id_seq', 7, true);


--
-- TOC entry 5088 (class 0 OID 0)
-- Dependencies: 225
-- Name: loans_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.loans_id_seq', 5, true);


--
-- TOC entry 5089 (class 0 OID 0)
-- Dependencies: 227
-- Name: reviews_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.reviews_id_seq', 3, true);


--
-- TOC entry 5090 (class 0 OID 0)
-- Dependencies: 219
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.users_id_seq', 4, true);


--
-- TOC entry 4910 (class 2606 OID 24954)
-- Name: bookmarks bookmarks_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bookmarks
    ADD CONSTRAINT bookmarks_pkey PRIMARY KEY (user_id, book_id);


--
-- TOC entry 4904 (class 2606 OID 24899)
-- Name: books books_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.books
    ADD CONSTRAINT books_pkey PRIMARY KEY (id);


--
-- TOC entry 4900 (class 2606 OID 24887)
-- Name: categories categories_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.categories
    ADD CONSTRAINT categories_name_key UNIQUE (name);


--
-- TOC entry 4902 (class 2606 OID 24885)
-- Name: categories categories_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.categories
    ADD CONSTRAINT categories_pkey PRIMARY KEY (id);


--
-- TOC entry 4906 (class 2606 OID 24914)
-- Name: loans loans_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.loans
    ADD CONSTRAINT loans_pkey PRIMARY KEY (id);


--
-- TOC entry 4908 (class 2606 OID 24936)
-- Name: reviews reviews_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.reviews
    ADD CONSTRAINT reviews_pkey PRIMARY KEY (id);


--
-- TOC entry 4894 (class 2606 OID 24967)
-- Name: users users_email_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key UNIQUE (email);


--
-- TOC entry 4896 (class 2606 OID 24874)
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- TOC entry 4898 (class 2606 OID 24876)
-- Name: users users_username_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_key UNIQUE (username);


--
-- TOC entry 4916 (class 2606 OID 24960)
-- Name: bookmarks bookmarks_book_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bookmarks
    ADD CONSTRAINT bookmarks_book_id_fkey FOREIGN KEY (book_id) REFERENCES public.books(id);


--
-- TOC entry 4917 (class 2606 OID 24955)
-- Name: bookmarks bookmarks_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bookmarks
    ADD CONSTRAINT bookmarks_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- TOC entry 4911 (class 2606 OID 24900)
-- Name: books books_category_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.books
    ADD CONSTRAINT books_category_id_fkey FOREIGN KEY (category_id) REFERENCES public.categories(id) ON DELETE SET NULL;


--
-- TOC entry 4912 (class 2606 OID 24920)
-- Name: loans loans_book_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.loans
    ADD CONSTRAINT loans_book_id_fkey FOREIGN KEY (book_id) REFERENCES public.books(id);


--
-- TOC entry 4913 (class 2606 OID 24915)
-- Name: loans loans_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.loans
    ADD CONSTRAINT loans_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- TOC entry 4914 (class 2606 OID 24942)
-- Name: reviews reviews_book_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.reviews
    ADD CONSTRAINT reviews_book_id_fkey FOREIGN KEY (book_id) REFERENCES public.books(id);


--
-- TOC entry 4915 (class 2606 OID 24937)
-- Name: reviews reviews_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.reviews
    ADD CONSTRAINT reviews_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id);


-- Completed on 2026-01-16 06:39:14

--
-- PostgreSQL database dump complete
--

