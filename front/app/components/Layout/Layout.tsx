import React, {ReactElement, ReactNode, useState} from "react";
import {
    DEFAULT_DESKTOP_LAYOUT,
    DEFAULT_LANDSCAPE_TABLET_LAYOUT,
    DEFAULT_PHONE_LAYOUT,
    DEFAULT_TABLET_LAYOUT,
    Layout as LayoutComponent,
    LayoutNavigationTree,
    SupportedPhoneLayout,
    SupportedTabletLayout,
    SupportedWideLayout,
    useLayoutNavigation,
    Configuration,
} from "@react-md/layout";
import {
    HomeSVGIcon,
    SecuritySVGIcon,
    SettingsSVGIcon,
    ShareSVGIcon,
    SnoozeSVGIcon,
    StarSVGIcon,
    StorageSVGIcon,
} from "@react-md/material-icons";

import NavItems from './NavItems'
import LinkUnstyled from "../LinkUnstyled";
import {useRouter} from "next/router";

interface LayoutProps {
    children: ReactNode
}

export default function Layout({children}: LayoutProps): ReactElement {
    const [desktopLayout] = useState<SupportedWideLayout>(DEFAULT_DESKTOP_LAYOUT);

    const {pathname} = useRouter()

    return (
        <Configuration>
            <LayoutComponent
                id="infra-workshop-layout"
                title=""
                navHeaderTitle="ToDo APP"
                desktopLayout={desktopLayout}
                treeProps={useLayoutNavigation(NavItems, pathname, LinkUnstyled)}
                mainProps={{component: "div"}}
            >
                {children}
            </LayoutComponent>
        </Configuration>
    );
}
