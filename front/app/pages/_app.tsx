import {ReactElement} from "react";
import type { AppProps } from 'next/app';

import '../styles/app.scss'
import '../styles/globals.css';
import Layout from '../components/Layout/Layout';

export default function App({ Component, pageProps }: AppProps): ReactElement {
  return (
      <Layout >
        <Component {...pageProps} />
      </Layout>
  )
}
