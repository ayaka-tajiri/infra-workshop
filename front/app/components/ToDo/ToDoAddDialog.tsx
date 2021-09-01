import React, {ReactElement, useState} from "react";
import {AddSVGIcon, Button, Dialog, DialogContent, DialogFooter, TextField} from "react-md";

interface ToDo {
    id: string
    title: string
}

interface ToDosAddDialogProps {
    addToDo: (ToDos: ToDo) => void
}

export default function ToDosAddDialog({addToDo}: ToDosAddDialogProps): ReactElement {
    const [state, setState] = useState({ visible: false, modal: false });
    const [toDoTitle, setToDoTitle] = useState("")
    const hide = (): void => {
        setState((prevState) => ({ ...prevState, visible: false }));
    };
    const show = (event: React.MouseEvent<HTMLButtonElement>): void => {
        setState({
            visible: true,
            modal: event.currentTarget.id === "ToDo-dialog-button",
        });
    };
    const { visible, modal } = state;

    function createToDo() {
            hide();
            const newToDo: ToDo = {id: '', title: toDoTitle}
            addToDo(newToDo)
    }
    return (
        <>
            <Button
                id="ToDo-dialog-button"
                floating="bottom-right"
                onClick={show}>
                <AddSVGIcon />
            </Button>
            <Dialog
                id="ToDo-add-dialog"
                modal={modal}
                visible={visible}
                onRequestClose={hide}
                aria-labelledby="add-dialog">
                <DialogContent>
                    <TextField
                        id="new-ToDo"
                        label="New ToDo"
                        theme={'underline'}
                        onChange={(event) => {
                            setToDoTitle(event.target.value)
                        }}
                    >
                    </TextField>
                </DialogContent>
                <DialogFooter>
                    <Button id="dialog-cancel" onClick={hide}>
                        Cancel
                    </Button>
                    <Button id="dialog-add" onClick={() => {
                        createToDo();
                    }}>
                        Add
                    </Button>
                </DialogFooter>
            </Dialog>
        </>
    )
}
