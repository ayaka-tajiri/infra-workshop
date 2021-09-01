import React, {ReactElement, useEffect, useState} from 'react';
import {TextField} from '@react-md/form'
import {Button, Grid, GridCell, Text} from 'react-md'
import {RemoveSVGIcon, AddSVGIcon, CheckBoxSVGIcon} from '@react-md/material-icons'
import styles from './ToDoList.module.scss'
import {InputToggle} from "@react-md/form/lib";

interface ToDoList {
    id: string
    content: string
    complete: boolean
}

interface ToDoListProps {
    toDoList: ToDoList[]
    createToDoList: (toDoList: ToDoList) => Promise<ToDoList>
    updateToDoList: (toDoList: ToDoList) => Promise<ToDoList>
    destroyToDoList: (toDoListId: string) => Promise<boolean>
}

export default function ToDoList({toDoList, createToDoList, updateToDoList, destroyToDoList}: ToDoListProps): ReactElement {
    const [selectedToDoList, setSelectedToDoList] = useState<ToDoList[]>([])
    useEffect(() => {
        const newToDoList = toDoList.map(value => {return {id: value.id, content: value.content, complete: value.complete}})
        setSelectedToDoList(newToDoList)
    }, [toDoList])

    function addToDoLit(): void {
        const addToDoList: ToDoList = {id: '', content: '', complete: false}
        createToDoList(addToDoList).then(() => {})
    }

    function changeToDoList(changeToDoList: ToDoList) {
        const index = getIndex(changeToDoList.id)
        selectedToDoList.splice(index, 1, changeToDoList)
        const newToDoList = selectedToDoList.slice()
        setSelectedToDoList(newToDoList)
    }

    function editToDoList(editToDoList: ToDoList): void {
        updateToDoList(editToDoList).then(() => {})
    }

    function deleteToDoList(id: string): void {
        destroyToDoList(id).then(() => {})
    }

    function getIndex(id: string): number {
        return toDoList.findIndex(toDoList => toDoList.id === id)
    }

    return (
        <div className={styles.div}>
            <Text type="headline-5">ToDo List</Text>
            {
                selectedToDoList.map(toDoListDetail =>
                    <Grid key={toDoListDetail.id}>
                        <GridCell colSpan={1} key={'remove_' + toDoListDetail.id} className={styles.item}>
                            <Button onClick={() => {
                                const id = toDoListDetail.id
                                deleteToDoList(id)
                            }}>
                                <RemoveSVGIcon/>
                            </Button>
                        </GridCell>
                        <GridCell colSpan={10} key={'toDoList_' + toDoListDetail.id}>
                            <TextField id={'content_' + toDoListDetail.id}
                                       placeholder='TODO'
                                       theme={'underline'}
                                       value={toDoListDetail.content}
                                       onChange={(event) => {
                                           toDoListDetail.content = event.target.value
                                           changeToDoList(toDoListDetail)
                                       }}
                                       onBlur={() => {
                                           editToDoList(toDoListDetail)
                                       }}
                            />
                        </GridCell>
                        <GridCell colSpan={1} key={'checkbox_' + toDoListDetail.id}>
                            <InputToggle
                                id={'complete_' + toDoListDetail.id}
                                name="complete"
                                type="checkbox"
                                checked={toDoListDetail.complete}
                                onChange={(event) => {
                                    console.log(event)
                                    console.log(toDoListDetail)
                                    if (event.target.value === 'on') {
                                        switch (toDoListDetail.complete){
                                            case true:
                                                toDoListDetail.complete = false
                                                break
                                            case false:
                                                toDoListDetail.complete = true
                                                break
                                            default:
                                                break
                                        }
                                        editToDoList(toDoListDetail)
                                    }
                                }}
                                icon={<CheckBoxSVGIcon />}
                            />
                        </GridCell>
                    </Grid>
                )
            }
            <Grid key={'add_button'}>
                <GridCell colSpan={1}>
                </GridCell>
                <GridCell colSpan={7}>
                    <Button className={styles.add_button} onClick={() => {
                        addToDoLit()
                    }}>
                        <AddSVGIcon/> add ToDo List
                    </Button>
                </GridCell>
                <GridCell colSpan={4}>
                </GridCell>
            </Grid>
        </div>
    )
}
