/* Copyright 2018 Sven van der Meer <vdmeer.sven@mykolab.com>
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * 
 *     http://www.apache.org/licenses/LICENSE-2.0
 * 
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package de.vandermeer.skb.framework;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Collection;
import java.util.List;

import de.vandermeer.asciilist.AsciiListContext;
import de.vandermeer.asciilist.itemize.ItemizeList;
import de.vandermeer.asciilist.itemize.ItemizeListContext;
import de.vandermeer.asciiparagraph.AP_Context;
import de.vandermeer.asciiparagraph.AsciiParagraph;
import de.vandermeer.skb.interfaces.transformers.textformat.TextAlignment;

/**
 * Tool that takes text and creates formatted text.
 *
 * @author     Sven van der Meer &lt;vdmeer.sven@mykolab.com&gt;
 * @version    0.0.1
 * @since      0.0.0
 */
public class Tool {

    /** The paragraph context Level 1. */
    public static final AP_Context AP_CONTEXT_L1 = new AP_Context()
            .setWidth(74)
            .setAlignment(TextAlignment.JUSTIFIED_LEFT)
            .setTextLeftMargin(4)
            .setTextBottomMargin(0)
            .setLineSeparator("\n");

    /** The paragraph context Level 2. */
    public static final AP_Context AP_CONTEXT_L2 = new AP_Context()
            .setWidth(70)
            .setAlignment(TextAlignment.JUSTIFIED_LEFT)
            .setTextLeftMargin(8)
            .setTextBottomMargin(0)
            .setLineSeparator("\n");

    /** The list context Level 1. */
    public static final AsciiListContext AL_CONTEXT_L1 = new ItemizeListContext()
            .setWidth(70)
            .setAlignment(TextAlignment.JUSTIFIED_LEFT)
            .setItemMargin(6)
            .setLineSeparator("\n");

    /** The list context Level 2. */
    public static final AsciiListContext AL_CONTEXT_L2 = new ItemizeListContext()
            .setWidth(66)
            .setAlignment(TextAlignment.JUSTIFIED_LEFT)
            .setItemMargin(10)
            .setLineSeparator("\n");

    /** The context level, to be set via CLI. */
    protected String ctxtLevel;

    /** The input file, once validated. */
    protected File inputFile;

    /**
     * Public main to start the tool.
     * 
     * @param args command line arguments
     */
    public static void main(String[] args) {
        Tool execs = new Tool();
        int ret = execs.execute(args);
        System.exit(ret);
    }

    /**
     * Creates a new Tool object.
     */
    public Tool() {
        // empty constructor
    }

    /**
     * Validates start conditions.
     * 
     * @param args command line arguments
     * @return true if everything was valid, false otherwise
     */
    public boolean validateStart(String[] args) {
        boolean ret = true;

        this.inputFile = new File(args[0]);
        if (!this.inputFile.exists()) {
            System.err.println("tool: file " + args[0] + " does not exist");
            System.err.println(2);
            ret = false;
        }
        if (!this.inputFile.canRead()) {
            System.err.println("tool: file " + args[0] + " not readable");
            System.err.println(3);
            ret = false;
        }

        switch (args[1]) {
        case "l1":
            this.ctxtLevel = "L1";
            break;
        case "l2":
            this.ctxtLevel = "L2";
            break;
        default:
            System.err.println("tool: unknown paragraph context: " + args[1]);
            System.err.println(3);
            ret = false;
            break;
        }

        return ret;
    }

    /**
     * Execute function, creates text from files in arguments
     * 
     * @param args the CLI arguments from the tool
     * @return 0 on success, other integer on error
     */
    public int execute(String[] args) {
        if (args.length != 2) {
            this.printHelp();
            System.exit(3);
        }
        if (!this.validateStart(args)) {
            System.exit(4);
        }

        ArrayList<String> items = new ArrayList<>();
        boolean isText = true;
        int paraCount = 0;
        try (BufferedReader br = new BufferedReader(new FileReader(this.inputFile))) {
            String line;
            while ((line = br.readLine()) != null) {
                if (line.equals("+") || line.equals(" +") || line.equals("")) {
                    if (isText && paraCount > 0) {
                        System.out.print("\n");
                    }
                    printText(items, isText);
                    items.clear();
                    if (isText) {
                        paraCount += 1;
                    }
                    isText = true;
                }
                else if (line.startsWith("* ")) {
                    items.add(line.substring("* ".length()));
                    isText = false;
                }
                else {
                    items.add(line);
                    isText = true;
                }
            }
        }
        catch (FileNotFoundException e) {
            System.err.println("tool: exception while reading input file: file not found");
        }
        catch (IOException e) {
            System.err.println("tool: exception while reading input file: IO exception");
        }

        if (isText && paraCount > 0) {
            System.out.print("\n");
        }
        printText(items, isText);

        return 0;
    }

    /**
     * Print text.
     * 
     * @param items the items that should be printed
     * @param isText flag for text, if false a list is printed
     */
    public void printText(List<String> items, boolean isText) {
        if (isText) {
            AP_Context ctxt = null;
            switch(this.ctxtLevel) {
                case "L1":
                    ctxt = AP_CONTEXT_L1;
                    break;
                case "L2":
                default:
                    ctxt = AP_CONTEXT_L2;
                    break;
            }
            AsciiParagraph ap = new AsciiParagraph(ctxt);
            ap.addText(items);
            //some problem with line separator in AP
            Collection<String> renderedAP = ap.renderAsCollection();
            for (String line : renderedAP) {
                System.out.print(line);
                System.out.print("\n");
            }
        }
        else {
            AsciiListContext ctxt = null;
            switch(this.ctxtLevel) {
                case "L1":
                    ctxt = AL_CONTEXT_L1;
                    break;
                case "L2":
                default:
                    ctxt = AL_CONTEXT_L2;
                    break;
            }
            ItemizeList al = new ItemizeList((ItemizeListContext) ctxt);
            for (String s : items) {
                al.addItem(s);
            }
            System.out.print(al.render());
            System.out.print("\n");
        }
    }

    /**
     * Print a simple help text.
     */
    public void printHelp() {
        System.out.println("SKB Framework");
        System.out.println("-h | --help for help");
        System.out.println("otherwise: <inputfile> <context: l1|l2>");
    }
}
