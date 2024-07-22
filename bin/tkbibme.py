#!/usr/bin/env python3
# -*- coding: utf-8 -*-

# Copyright 2024, Antonio Alvarado Hernández <tnotstar@gmail.com>

import tkinter as tk

import tkinter as tk
from tkinter import messagebox

class MainFrame:
    """TODO"""

    def __init__(self, parent):
        self.parent = parent

        self.input_text1 = tk.StringVar()
        self.input_text2 = tk.StringVar()

        input_label1 = tk.Label(parent, text="Input Text 1:")
        input_label1.pack()
        input_entry1 = tk.Entry(parent, textvariable=self.input_text1)
        input_entry1.pack()

        input_label2 = tk.Label(parent, text="Input Text 2:")
        input_label2.pack()
        input_entry2 = tk.Entry(parent, textvariable=self.input_text2)
        input_entry2.pack()

        submit_button = tk.Button(parent, text="Submit", command=self.submit)
        submit_button.pack()

        clear_button = tk.Button(parent, text="Clear", command=self.clear)
        clear_button.pack()

    def submit(self):
        input1 = self.input_text1.get()
        input2 = self.input_text2.get()
        messagebox.showinfo("Submitted", f"Input Text 1: {input1}\nInput Text 2: {input2}")

    def clear(self):
        self.input_text1.set("")
        self.input_text2.set("")

def main():
    root = tk.Tk()
    root.title("Input Frame")

    frame = MainFrame(root)
    root.mainloop()

if __name__ == "__main__":
    main()

# EOF
