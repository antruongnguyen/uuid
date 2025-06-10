use clap::{Parser, ValueEnum};
use clipboard::{ClipboardContext, ClipboardProvider};
use std::fmt::Write as FmtWrite;
use uuid::{
  Uuid,
  v1::{Context, Timestamp},
};

#[derive(Parser, Debug)]
#[command(author, about, long_about = None)]
#[command(about = "A CLI tool to generate UUIDs")]
#[command(disable_version_flag = true)]
struct Args {
  /// UUID version to generate
  #[arg(short = 't', long = "type", value_enum, default_value_t = UuidVersion::V4)]
  version: UuidVersion,

  /// Convert UUID to uppercase
  #[arg(short, long, default_value_t = false)]
  uppercase: bool,

  /// Number of UUIDs to generate
  #[arg(short, long, default_value_t = 1)]
  count: u32,

  /// Copy the generated UUID to clipboard (only works with count=1)
  #[arg(short = 'p', long, default_value_t = false)]
  copy: bool,

  /// Namespace for v3 and v5 UUIDs (required for these versions)
  #[arg(short, long)]
  namespace: Option<String>,

  /// Name for v3 and v5 UUIDs (required for these versions)
  #[arg(short = 'a', long)]
  name: Option<String>,

  /// User-defined data for v8 UUIDs (required for v8)
  #[arg(short = 'd', long)]
  data: Option<String>,
}

#[derive(Copy, Clone, PartialEq, Eq, PartialOrd, Ord, ValueEnum, Debug)]
enum UuidVersion {
  V1,
  V3,
  V4,
  V5,
  V6,
  V7,
  V8,
}

fn main() {
  let args = Args::parse();

  // Validate arguments for specific UUID versions
  match args.version {
    UuidVersion::V3 | UuidVersion::V5 => {
      if args.namespace.is_none() || args.name.is_none() {
        eprintln!(
          "Error: --namespace and --name are required for UUID version {:?}",
          args.version
        );
        std::process::exit(1);
      }
    }
    UuidVersion::V8 => {
      if args.data.is_none() {
        eprintln!("Error: --data is required for UUID version V8");
        std::process::exit(1);
      }
    }
    _ => {}
  }

  // Generate UUIDs
  let mut all_uuids = String::new();
  for _ in 0..args.count {
    let uuid = generate_uuid(&args);
    let uuid_str = if args.uppercase {
      uuid.to_string().to_uppercase()
    } else {
      uuid.to_string()
    };

    println!("{}", uuid_str);

    if args.count == 1 {
      all_uuids = uuid_str;
    } else {
      writeln!(all_uuids, "{}", uuid_str).unwrap();
    }
  }

  // Copy to clipboard if requested
  if args.copy {
    if args.count > 1 {
      eprintln!("Warning: Copying multiple UUIDs to clipboard");
    }

    match ClipboardProvider::new() {
      Ok(mut ctx) => {
        let ctx: &mut ClipboardContext = &mut ctx;
        if let Err(e) = ctx.set_contents(all_uuids) {
          eprintln!("Failed to copy to clipboard: {}", e);
        }
      }
      Err(e) => {
        eprintln!("Failed to access clipboard: {}", e);
      }
    }
  }
}

fn generate_uuid(args: &Args) -> Uuid {
  match args.version {
    UuidVersion::V1 => {
      let context = Context::new(42);
      let ts = Timestamp::now(context);
      // Create a node ID (MAC address)
      let node_id = [0x01, 0x23, 0x45, 0x67, 0x89, 0xAB];
      Uuid::new_v1(ts, &node_id)
    }
    UuidVersion::V3 => {
      let namespace = Uuid::parse_str(args.namespace.as_ref().unwrap()).unwrap_or_else(|_| {
        eprintln!("Error: Invalid namespace UUID format");
        std::process::exit(1);
      });
      Uuid::new_v3(&namespace, args.name.as_ref().unwrap().as_bytes())
    }
    UuidVersion::V4 => Uuid::new_v4(),
    UuidVersion::V5 => {
      let namespace = Uuid::parse_str(args.namespace.as_ref().unwrap()).unwrap_or_else(|_| {
        eprintln!("Error: Invalid namespace UUID format");
        std::process::exit(1);
      });
      Uuid::new_v5(&namespace, args.name.as_ref().unwrap().as_bytes())
    }
    UuidVersion::V6 => {
      let context = Context::new(42);
      let ts = Timestamp::now(context);
      // Create a node ID (MAC address)
      let node_id = [0x01, 0x23, 0x45, 0x67, 0x89, 0xAB];
      Uuid::new_v6(ts, &node_id)
    }
    UuidVersion::V7 => {
      let ts = Timestamp::now(Context::new(42));
      Uuid::new_v7(ts)
    }
    UuidVersion::V8 => {
      // Convert input string to bytes for v8
      let data = args.data.as_ref().unwrap().as_bytes();
      // Use only up to 16 bytes for UUID v8
      let mut bytes = [0u8; 16];
      for (i, &byte) in data.iter().enumerate().take(16) {
        bytes[i] = byte;
      }
      // Set version bits
      bytes[6] = (bytes[6] & 0x0F) | 0x80;
      // Set variant bits
      bytes[8] = (bytes[8] & 0x3F) | 0x80;

      Uuid::from_bytes(bytes)
    }
  }
}
