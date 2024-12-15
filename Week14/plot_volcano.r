# Load necessary libraries
library(ggplot2)
library(DESeq2)
library(dplyr)

# Specify the file path to the DESeq2 results
file_path <- "res/deseq2.csv"

# Read in the DESeq2 results
deseq2_results <- read.csv(file_path)

# Create a volcano plot
volcano_plot <- function(deseq2_results) {
    # Add a column for significance
    deseq2_results$significant <- "Not Significant"
    deseq2_results$significant[deseq2_results$PAdj < 0.05 & abs(deseq2_results$log2FoldChange) > 1] <- "Significant"
    
    # Identify the top 20 genes with the smallest adjusted p-values
    top_genes <- deseq2_results %>% 
        arrange(PAdj) %>% 
        head(10)
    
    # Create the plot
    p <- ggplot(deseq2_results, aes(x = log2FoldChange, y = -log10(PAdj), color = significant)) +
        geom_point(alpha = 0.5) +
        scale_color_manual(values = c("Not Significant" = "grey", "Significant" = "red")) +
        theme_minimal() +
        labs(title = "Volcano Plot", x = "Log2 Fold Change", y = "-Log10 Adjusted P-value") +
        geom_text(data = top_genes, aes(label = gene), vjust = 1, hjust = 1, size = 3)
    
    # Save the plot as a PDF
    ggsave("plots/volcano_plot.pdf", plot = p)
}

# Run the function
volcano_plot(deseq2_results)