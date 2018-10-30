--
-- PostgreSQL database dump
--

-- Dumped from database version 9.5.3
-- Dumped by pg_dump version 9.5.4

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: authengine_test; Type: SCHEMA; Schema: -; Owner: weatherproof_rw
--

CREATE SCHEMA authengine_test;


ALTER SCHEMA authengine_test OWNER TO weatherproof_rw;

SET search_path = authengine_test, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: apikey_authorization; Type: TABLE; Schema: authengine_test; Owner: weatherproof_rw
--

CREATE TABLE apikey_authorization (
    apikey character varying(255) NOT NULL,
    service character varying(255) NOT NULL,
    token character varying(255) NOT NULL,
    id bigint NOT NULL,
    CONSTRAINT authorization_apikey_not_empty CHECK (((apikey)::text <> ''::text)),
    CONSTRAINT service_not_empty CHECK (((service)::text <> ''::text)),
    CONSTRAINT token_not_empty CHECK (((token)::text <> ''::text))
);


ALTER TABLE apikey_authorization OWNER TO weatherproof_rw;

--
-- Name: TABLE apikey_authorization; Type: COMMENT; Schema: authengine_test; Owner: weatherproof_rw
--

COMMENT ON TABLE apikey_authorization IS 'Apikeylle annetut BrainStorm - autorisointitokenit';


--
-- Name: COLUMN apikey_authorization.apikey; Type: COMMENT; Schema: authengine_test; Owner: weatherproof_rw
--

COMMENT ON COLUMN apikey_authorization.apikey IS 'Apikey';


--
-- Name: COLUMN apikey_authorization.service; Type: COMMENT; Schema: authengine_test; Owner: weatherproof_rw
--

COMMENT ON COLUMN apikey_authorization.service IS 'BrainStorm palvelu';


--
-- Name: COLUMN apikey_authorization.token; Type: COMMENT; Schema: authengine_test; Owner: weatherproof_rw
--

COMMENT ON COLUMN apikey_authorization.token IS 'Autorisointitoken';


--
-- Name: apikey_authorization_id_seq; Type: SEQUENCE; Schema: authengine_test; Owner: weatherproof_rw
--

CREATE SEQUENCE apikey_authorization_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE apikey_authorization_id_seq OWNER TO weatherproof_rw;

--
-- Name: apikey_authorization_id_seq; Type: SEQUENCE OWNED BY; Schema: authengine_test; Owner: weatherproof_rw
--

ALTER SEQUENCE apikey_authorization_id_seq OWNED BY apikey_authorization.id;


--
-- Name: apikey_authorization_tokens; Type: TABLE; Schema: authengine_test; Owner: weatherproof_rw
--

CREATE TABLE apikey_authorization_tokens (
    service character varying(255) NOT NULL,
    token character varying(255) NOT NULL,
    value character varying(255) NOT NULL,
    id bigint NOT NULL,
    CONSTRAINT service_not_empty CHECK (((service)::text <> ''::text)),
    CONSTRAINT token_not_empty CHECK (((token)::text <> ''::text)),
    CONSTRAINT value_not_empty CHECK (((value)::text <> ''::text))
);


ALTER TABLE apikey_authorization_tokens OWNER TO weatherproof_rw;

--
-- Name: TABLE apikey_authorization_tokens; Type: COMMENT; Schema: authengine_test; Owner: weatherproof_rw
--

COMMENT ON TABLE apikey_authorization_tokens IS 'Apikeyden autorisointitokenit';


--
-- Name: COLUMN apikey_authorization_tokens.service; Type: COMMENT; Schema: authengine_test; Owner: weatherproof_rw
--

COMMENT ON COLUMN apikey_authorization_tokens.service IS 'BrainStorm palvelun nimi';


--
-- Name: COLUMN apikey_authorization_tokens.token; Type: COMMENT; Schema: authengine_test; Owner: weatherproof_rw
--

COMMENT ON COLUMN apikey_authorization_tokens.token IS 'Autorisointitokenin nimi';


--
-- Name: COLUMN apikey_authorization_tokens.value; Type: COMMENT; Schema: authengine_test; Owner: weatherproof_rw
--

COMMENT ON COLUMN apikey_authorization_tokens.value IS 'Autorisointitokenin arvo';


--
-- Name: apikey_authorization_tokens_id_seq; Type: SEQUENCE; Schema: authengine_test; Owner: weatherproof_rw
--

CREATE SEQUENCE apikey_authorization_tokens_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE apikey_authorization_tokens_id_seq OWNER TO weatherproof_rw;

--
-- Name: apikey_authorization_tokens_id_seq; Type: SEQUENCE OWNED BY; Schema: authengine_test; Owner: weatherproof_rw
--

ALTER SEQUENCE apikey_authorization_tokens_id_seq OWNED BY apikey_authorization_tokens.id;


--
-- Name: id; Type: DEFAULT; Schema: authengine_test; Owner: weatherproof_rw
--

ALTER TABLE ONLY apikey_authorization ALTER COLUMN id SET DEFAULT nextval('apikey_authorization_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: authengine_test; Owner: weatherproof_rw
--

ALTER TABLE ONLY apikey_authorization_tokens ALTER COLUMN id SET DEFAULT nextval('apikey_authorization_tokens_id_seq'::regclass);


--
-- Data for Name: apikey_authorization; Type: TABLE DATA; Schema: authengine_test; Owner: weatherproof_rw
--

COPY apikey_authorization (apikey, service, token, id) FROM stdin;
testkey	testservice	token1	1
testkey	testservice	token2	2
testkey2	testservice	token2	3
testkey_wildcard	testservice	*	4
testkey2	testservice2	token1	5
\.


--
-- Name: apikey_authorization_id_seq; Type: SEQUENCE SET; Schema: authengine_test; Owner: weatherproof_rw
--

SELECT pg_catalog.setval('apikey_authorization_id_seq', 37, true);


--
-- Data for Name: apikey_authorization_tokens; Type: TABLE DATA; Schema: authengine_test; Owner: weatherproof_rw
--

COPY apikey_authorization_tokens (service, token, value, id) FROM stdin;
testservice	token1	value1	1
testservice	token1	value2	2
testservice	token2	value3	3
testservice2	token1	value1	4
\.


--
-- Name: apikey_authorization_tokens_id_seq; Type: SEQUENCE SET; Schema: authengine_test; Owner: weatherproof_rw
--

SELECT pg_catalog.setval('apikey_authorization_tokens_id_seq', 36, true);


--
-- Name: authengine_test; Type: ACL; Schema: -; Owner: weatherproof_rw
--

REVOKE ALL ON SCHEMA authengine_test FROM PUBLIC;
REVOKE ALL ON SCHEMA authengine_test FROM weatherproof_rw;
GRANT ALL ON SCHEMA authengine_test TO weatherproof_rw;
GRANT USAGE ON SCHEMA authengine_test TO weatherproof_ro;


--
-- Name: apikey_authorization; Type: ACL; Schema: authengine_test; Owner: weatherproof_rw
--

REVOKE ALL ON TABLE apikey_authorization FROM PUBLIC;
REVOKE ALL ON TABLE apikey_authorization FROM weatherproof_rw;
GRANT ALL ON TABLE apikey_authorization TO weatherproof_rw;
GRANT SELECT ON TABLE apikey_authorization TO PUBLIC;
GRANT SELECT ON TABLE apikey_authorization TO weatherproof_ro;


--
-- Name: apikey_authorization_id_seq; Type: ACL; Schema: authengine_test; Owner: weatherproof_rw
--

REVOKE ALL ON SEQUENCE apikey_authorization_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE apikey_authorization_id_seq FROM weatherproof_rw;
GRANT ALL ON SEQUENCE apikey_authorization_id_seq TO weatherproof_rw;
GRANT SELECT ON SEQUENCE apikey_authorization_id_seq TO PUBLIC;


--
-- Name: apikey_authorization_tokens; Type: ACL; Schema: authengine_test; Owner: weatherproof_rw
--

REVOKE ALL ON TABLE apikey_authorization_tokens FROM PUBLIC;
REVOKE ALL ON TABLE apikey_authorization_tokens FROM weatherproof_rw;
GRANT ALL ON TABLE apikey_authorization_tokens TO weatherproof_rw;
GRANT SELECT ON TABLE apikey_authorization_tokens TO weatherproof_ro;
GRANT SELECT ON TABLE apikey_authorization_tokens TO PUBLIC;


--
-- Name: apikey_authorization_tokens_id_seq; Type: ACL; Schema: authengine_test; Owner: weatherproof_rw
--

REVOKE ALL ON SEQUENCE apikey_authorization_tokens_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE apikey_authorization_tokens_id_seq FROM weatherproof_rw;
GRANT ALL ON SEQUENCE apikey_authorization_tokens_id_seq TO weatherproof_rw;
GRANT SELECT ON SEQUENCE apikey_authorization_tokens_id_seq TO PUBLIC;


--
-- PostgreSQL database dump complete
--

