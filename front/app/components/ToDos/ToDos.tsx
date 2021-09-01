import React, {ReactElement, useEffect, useState} from "react";
import Link from "next/link";
import {Table, TableBody, TableCell, TableContainer, TableRow} from "@react-md/table";
import styles from "./ToDos.module.scss";
import {Text} from "react-md";
import ToDoAddDialog from "../ToDo/ToDoAddDialog";
import ToDoDeleteDialog from "../ToDo/ToDoDeleteDialog";

interface ToDo {
    id: string
    title: string
}

interface ToDoProps {
    toDos: ToDo[]
    deleteToDo: (toDoId: string) => void
    addToDo: (toDo: ToDo) => void
}

export default function ToDos({toDos, deleteToDo, addToDo}: ToDoProps): ReactElement {
    const [selectedToDo, setSelectedToDo] = useState<ToDo[]>([])

    useEffect(() => {
        setSelectedToDo(toDos)
    }, [toDos])

    return (
        <div className={styles.div}>
            <Text type="headline-5">ToDo</Text>
            <TableContainer>
                <Table fullWidth>
                    <TableBody>
                        {
                            selectedToDo.map(toDo =>
                                <TableRow key={toDo.id}>
                                    <Link href={{
                                        pathname: "/todo/[id]",
                                        query: {id: [toDo.id]},
                                    }}
                                          key={'link_' + toDo.id}
                                          passHref>
                                        <TableCell grow={true}>{toDo.title}</TableCell>
                                    </Link>
                                    <TableCell grow={false}>
                                        <ToDoDeleteDialog toDoId={toDo.id} destroyToDos={deleteToDo}/>
                                    </TableCell>
                                </TableRow>
                            )
                        }
                    </TableBody>
                </Table>
            </TableContainer>
            <ToDoAddDialog addToDo={addToDo}/>
        </div>
    )
}
